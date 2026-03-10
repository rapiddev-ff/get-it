import { createClient } from "https://esm.sh/@supabase/supabase-js@2";

const corsHeaders = {
  "Access-Control-Allow-Origin": "*",
  "Access-Control-Allow-Headers":
    "authorization, x-client-info, apikey, content-type",
};

interface TrackingResult {
  carrier: string;
  status: string; // 'in_transit' | 'delivered' | 'unknown' | 'error'
  deliveredAt?: string;
  lastUpdate?: string;
  error?: string;
}

// Detect carrier from tracking number format
function detectCarrier(trackingNumber: string): string | null {
  const tn = trackingNumber.replace(/\s/g, "").toUpperCase();

  // UPS: 1Z followed by 16 alphanumeric chars
  if (/^1Z[A-Z0-9]{16}$/.test(tn)) return "ups";

  // FedEx: 12, 15, 20, or 22 digits
  if (/^\d{12}$/.test(tn) || /^\d{15}$/.test(tn) || /^\d{20}$/.test(tn) || /^\d{22}$/.test(tn)) {
    return "fedex";
  }

  // USPS: 20-22 digits, or starts with specific prefixes
  if (/^\d{20,22}$/.test(tn)) return "usps";
  if (/^(94|93|92|91|90)\d{18,20}$/.test(tn)) return "usps";
  if (/^[A-Z]{2}\d{9}US$/i.test(tn)) return "usps";

  return null;
}

// Track via UPS API
async function trackUPS(trackingNumber: string): Promise<TrackingResult> {
  const clientId = Deno.env.get("UPS_CLIENT_ID");
  const clientSecret = Deno.env.get("UPS_CLIENT_SECRET");

  if (!clientId || !clientSecret) {
    return { carrier: "ups", status: "error", error: "UPS API credentials not configured" };
  }

  try {
    // Get OAuth token
    const tokenResp = await fetch("https://onlinetools.ups.com/security/v1/oauth/token", {
      method: "POST",
      headers: {
        "Content-Type": "application/x-www-form-urlencoded",
        "Authorization": `Basic ${btoa(`${clientId}:${clientSecret}`)}`,
      },
      body: "grant_type=client_credentials",
    });

    if (!tokenResp.ok) {
      return { carrier: "ups", status: "error", error: "UPS auth failed" };
    }

    const tokenData = await tokenResp.json();
    const accessToken = tokenData.access_token;

    // Track package
    const trackResp = await fetch(
      `https://onlinetools.ups.com/api/track/v1/details/${trackingNumber}`,
      {
        headers: {
          "Authorization": `Bearer ${accessToken}`,
          "transId": crypto.randomUUID(),
          "transactionSrc": "getit-app",
        },
      }
    );

    if (!trackResp.ok) {
      return { carrier: "ups", status: "error", error: "UPS tracking request failed" };
    }

    const trackData = await trackResp.json();
    const shipment = trackData?.trackResponse?.shipment?.[0];
    const pkg = shipment?.package?.[0];
    const currentStatus = pkg?.currentStatus?.description?.toLowerCase() ?? "";

    if (currentStatus.includes("delivered")) {
      const deliveryDate = pkg?.deliveryDate?.[0]?.date;
      const deliveryTime = pkg?.deliveryTime?.endTime;
      let deliveredAt: string | undefined;
      if (deliveryDate) {
        // UPS date format: YYYYMMDD
        const year = deliveryDate.substring(0, 4);
        const month = deliveryDate.substring(4, 6);
        const day = deliveryDate.substring(6, 8);
        deliveredAt = `${year}-${month}-${day}`;
        if (deliveryTime) {
          deliveredAt += `T${deliveryTime.substring(0, 2)}:${deliveryTime.substring(2, 4)}:00Z`;
        }
      }
      return { carrier: "ups", status: "delivered", deliveredAt };
    }

    return { carrier: "ups", status: "in_transit", lastUpdate: currentStatus };
  } catch (e) {
    return { carrier: "ups", status: "error", error: String(e) };
  }
}

// Track via USPS API (Web Tools)
async function trackUSPS(trackingNumber: string): Promise<TrackingResult> {
  const userId = Deno.env.get("USPS_USER_ID");

  if (!userId) {
    return { carrier: "usps", status: "error", error: "USPS API credentials not configured" };
  }

  try {
    const xml = `<TrackRequest USERID="${userId}"><TrackID ID="${trackingNumber}"></TrackID></TrackRequest>`;
    const resp = await fetch(
      `https://secure.shippingapis.com/ShippingAPI.dll?API=TrackV2&XML=${encodeURIComponent(xml)}`
    );

    if (!resp.ok) {
      return { carrier: "usps", status: "error", error: "USPS tracking request failed" };
    }

    const text = await resp.text();

    // Parse XML response for delivery status
    if (text.includes("Delivered")) {
      // Extract delivery date if available
      const dateMatch = text.match(/<EventDate>([^<]+)<\/EventDate>/);
      const timeMatch = text.match(/<EventTime>([^<]+)<\/EventTime>/);
      let deliveredAt: string | undefined;
      if (dateMatch) {
        deliveredAt = dateMatch[1];
        if (timeMatch) {
          deliveredAt += `T${timeMatch[1]}`;
        }
      }
      return { carrier: "usps", status: "delivered", deliveredAt };
    }

    return { carrier: "usps", status: "in_transit" };
  } catch (e) {
    return { carrier: "usps", status: "error", error: String(e) };
  }
}

// Track via FedEx API
async function trackFedEx(trackingNumber: string): Promise<TrackingResult> {
  const clientId = Deno.env.get("FEDEX_CLIENT_ID");
  const clientSecret = Deno.env.get("FEDEX_CLIENT_SECRET");

  if (!clientId || !clientSecret) {
    return { carrier: "fedex", status: "error", error: "FedEx API credentials not configured" };
  }

  try {
    // Get OAuth token
    const tokenResp = await fetch("https://apis.fedex.com/oauth/token", {
      method: "POST",
      headers: { "Content-Type": "application/x-www-form-urlencoded" },
      body: `grant_type=client_credentials&client_id=${clientId}&client_secret=${clientSecret}`,
    });

    if (!tokenResp.ok) {
      return { carrier: "fedex", status: "error", error: "FedEx auth failed" };
    }

    const tokenData = await tokenResp.json();

    // Track package
    const trackResp = await fetch("https://apis.fedex.com/track/v1/trackingnumbers", {
      method: "POST",
      headers: {
        "Content-Type": "application/json",
        "Authorization": `Bearer ${tokenData.access_token}`,
      },
      body: JSON.stringify({
        trackingInfo: [{ trackingNumberInfo: { trackingNumber } }],
        includeDetailedScans: false,
      }),
    });

    if (!trackResp.ok) {
      return { carrier: "fedex", status: "error", error: "FedEx tracking request failed" };
    }

    const trackData = await trackResp.json();
    const result = trackData?.output?.completeTrackResults?.[0]?.trackResults?.[0];
    const latestStatus = result?.latestStatusDetail?.statusByLocale?.toLowerCase() ?? "";

    if (latestStatus.includes("delivered")) {
      const deliveryTs = result?.latestStatusDetail?.scanLocation?.residential
        ? result?.dateAndTimes?.find((d: { type: string }) => d.type === "ACTUAL_DELIVERY")?.dateTime
        : undefined;
      return { carrier: "fedex", status: "delivered", deliveredAt: deliveryTs };
    }

    return { carrier: "fedex", status: "in_transit", lastUpdate: latestStatus };
  } catch (e) {
    return { carrier: "fedex", status: "error", error: String(e) };
  }
}

async function trackPackage(
  trackingNumber: string,
  knownCarrier?: string | null
): Promise<TrackingResult> {
  const carrier = knownCarrier || detectCarrier(trackingNumber);

  switch (carrier) {
    case "ups":
      return trackUPS(trackingNumber);
    case "usps":
      return trackUSPS(trackingNumber);
    case "fedex":
      return trackFedEx(trackingNumber);
    default:
      // Try all carriers
      for (const tryFn of [trackUPS, trackUSPS, trackFedEx]) {
        const result = await tryFn(trackingNumber);
        if (result.status !== "error") return result;
      }
      return { carrier: "unknown", status: "unknown", error: "Could not determine carrier" };
  }
}

Deno.serve(async (req: Request) => {
  if (req.method === "OPTIONS") {
    return new Response("ok", { headers: corsHeaders });
  }

  try {
    const supabaseUrl = Deno.env.get("SUPABASE_URL")!;
    const serviceRoleKey = Deno.env.get("SUPABASE_SERVICE_ROLE_KEY")!;
    const supabase = createClient(supabaseUrl, serviceRoleKey);

    // Fetch all shipped orders with tracking numbers
    const { data: orders, error } = await supabase
      .from("orders")
      .select("id, tracking_number, shipping_carrier, total_amount")
      .eq("status", "shipped")
      .not("tracking_number", "is", null)
      .is("deleted_at", null);

    if (error) {
      return new Response(JSON.stringify({ error: error.message }), {
        status: 500,
        headers: { ...corsHeaders, "Content-Type": "application/json" },
      });
    }

    const results: { orderId: string; result: TrackingResult }[] = [];

    for (const order of orders ?? []) {
      if (!order.tracking_number) continue;

      const result = await trackPackage(order.tracking_number, order.shipping_carrier);
      results.push({ orderId: order.id, result });

      if (result.status === "delivered") {
        // Update order status to delivered
        const updateData: Record<string, string> = {
          status: "delivered",
          updated_at: new Date().toISOString(),
        };

        if (result.deliveredAt) {
          updateData.delivered_at = result.deliveredAt;
        } else {
          updateData.delivered_at = new Date().toISOString();
        }

        if (result.carrier && !order.shipping_carrier) {
          updateData.shipping_carrier = result.carrier;
        }

        await supabase.from("orders").update(updateData).eq("id", order.id);
      }
    }

    return new Response(
      JSON.stringify({
        checked: results.length,
        delivered: results.filter((r) => r.result.status === "delivered").length,
        results,
      }),
      {
        status: 200,
        headers: { ...corsHeaders, "Content-Type": "application/json" },
      }
    );
  } catch (e) {
    return new Response(JSON.stringify({ error: String(e) }), {
      status: 500,
      headers: { ...corsHeaders, "Content-Type": "application/json" },
    });
  }
});
