import { createClient } from "https://esm.sh/@supabase/supabase-js@2";

const corsHeaders = {
  "Access-Control-Allow-Origin": "*",
  "Access-Control-Allow-Headers":
    "authorization, x-client-info, apikey, content-type",
};

interface UPSTokenResponse {
  access_token: string;
  token_type: string;
  issued_at: string;
  expires_in: string;
  status: string;
  refresh_token?: string;
  refresh_token_issued_at?: string;
  refresh_token_expires_in?: string;
}

// Exchange authorization code for access token
async function exchangeCodeForToken(
  code: string,
  redirectUri: string
): Promise<UPSTokenResponse> {
  const clientId = Deno.env.get("UPS_CLIENT_ID")!;
  const clientSecret = Deno.env.get("UPS_CLIENT_SECRET")!;

  const resp = await fetch(
    "https://onlinetools.ups.com/security/v1/oauth/token",
    {
      method: "POST",
      headers: {
        "Content-Type": "application/x-www-form-urlencoded",
        Authorization: `Basic ${btoa(`${clientId}:${clientSecret}`)}`,
      },
      body: new URLSearchParams({
        grant_type: "authorization_code",
        code,
        redirect_uri: redirectUri,
      }),
    }
  );

  if (!resp.ok) {
    const errorText = await resp.text();
    throw new Error(`UPS token exchange failed (${resp.status}): ${errorText}`);
  }

  return resp.json();
}

// Refresh an existing token
async function refreshToken(
  refreshTokenValue: string
): Promise<UPSTokenResponse> {
  const clientId = Deno.env.get("UPS_CLIENT_ID")!;
  const clientSecret = Deno.env.get("UPS_CLIENT_SECRET")!;

  const resp = await fetch(
    "https://onlinetools.ups.com/security/v1/oauth/token",
    {
      method: "POST",
      headers: {
        "Content-Type": "application/x-www-form-urlencoded",
        Authorization: `Basic ${btoa(`${clientId}:${clientSecret}`)}`,
      },
      body: new URLSearchParams({
        grant_type: "refresh_token",
        refresh_token: refreshTokenValue,
      }),
    }
  );

  if (!resp.ok) {
    const errorText = await resp.text();
    throw new Error(`UPS token refresh failed (${resp.status}): ${errorText}`);
  }

  return resp.json();
}

Deno.serve(async (req: Request) => {
  // Handle CORS preflight
  if (req.method === "OPTIONS") {
    return new Response("ok", { headers: corsHeaders });
  }

  try {
    const url = new URL(req.url);

    // --- GET: UPS redirects here after user authorizes ---
    if (req.method === "GET") {
      const code = url.searchParams.get("code");
      const error = url.searchParams.get("error");

      if (error) {
        return new Response(
          JSON.stringify({ error: `UPS authorization denied: ${error}` }),
          {
            status: 400,
            headers: { ...corsHeaders, "Content-Type": "application/json" },
          }
        );
      }

      if (!code) {
        return new Response(
          JSON.stringify({ error: "Missing authorization code" }),
          {
            status: 400,
            headers: { ...corsHeaders, "Content-Type": "application/json" },
          }
        );
      }

      // Build the redirect URI (must match what was registered in UPS portal)
      const redirectUri = `${url.origin}${url.pathname}`;

      const tokenData = await exchangeCodeForToken(code, redirectUri);

      // Store the token in Supabase for future use
      const supabase = createClient(
        Deno.env.get("SUPABASE_URL")!,
        Deno.env.get("SUPABASE_SERVICE_ROLE_KEY")!
      );

      const expiresAt = new Date(
        Date.now() + parseInt(tokenData.expires_in) * 1000
      ).toISOString();

      await supabase.from("api_tokens").upsert(
        {
          provider: "ups",
          access_token: tokenData.access_token,
          refresh_token: tokenData.refresh_token ?? null,
          expires_at: expiresAt,
          updated_at: new Date().toISOString(),
        },
        { onConflict: "provider" }
      );

      return new Response(
        JSON.stringify({
          success: true,
          message: "UPS authorization successful. Token stored.",
          expires_at: expiresAt,
        }),
        {
          status: 200,
          headers: { ...corsHeaders, "Content-Type": "application/json" },
        }
      );
    }

    // --- POST: Refresh token or get current token status ---
    if (req.method === "POST") {
      const authHeader = req.headers.get("authorization");
      if (!authHeader) {
        return new Response(
          JSON.stringify({ error: "Missing authorization" }),
          {
            status: 401,
            headers: { ...corsHeaders, "Content-Type": "application/json" },
          }
        );
      }

      const supabase = createClient(
        Deno.env.get("SUPABASE_URL")!,
        Deno.env.get("SUPABASE_ANON_KEY")!,
        { global: { headers: { Authorization: authHeader } } }
      );

      const {
        data: { user },
        error: authError,
      } = await supabase.auth.getUser();

      if (authError || !user) {
        return new Response(JSON.stringify({ error: "Unauthorized" }), {
          status: 401,
          headers: { ...corsHeaders, "Content-Type": "application/json" },
        });
      }

      const body = await req.json();
      const action = body.action; // "refresh" | "status"

      const adminSupabase = createClient(
        Deno.env.get("SUPABASE_URL")!,
        Deno.env.get("SUPABASE_SERVICE_ROLE_KEY")!
      );

      const { data: tokenRecord, error: fetchError } = await adminSupabase
        .from("api_tokens")
        .select("*")
        .eq("provider", "ups")
        .single();

      if (fetchError || !tokenRecord) {
        return new Response(
          JSON.stringify({
            error: "No UPS token found. Complete OAuth flow first.",
          }),
          {
            status: 404,
            headers: { ...corsHeaders, "Content-Type": "application/json" },
          }
        );
      }

      if (action === "refresh" && tokenRecord.refresh_token) {
        const newTokenData = await refreshToken(tokenRecord.refresh_token);

        const expiresAt = new Date(
          Date.now() + parseInt(newTokenData.expires_in) * 1000
        ).toISOString();

        await adminSupabase
          .from("api_tokens")
          .update({
            access_token: newTokenData.access_token,
            refresh_token: newTokenData.refresh_token ?? tokenRecord.refresh_token,
            expires_at: expiresAt,
            updated_at: new Date().toISOString(),
          })
          .eq("provider", "ups");

        return new Response(
          JSON.stringify({
            success: true,
            message: "Token refreshed",
            expires_at: expiresAt,
          }),
          {
            status: 200,
            headers: { ...corsHeaders, "Content-Type": "application/json" },
          }
        );
      }

      // Return token status
      const isExpired = new Date(tokenRecord.expires_at) < new Date();
      return new Response(
        JSON.stringify({
          provider: "ups",
          has_token: true,
          expired: isExpired,
          expires_at: tokenRecord.expires_at,
          has_refresh_token: !!tokenRecord.refresh_token,
        }),
        {
          status: 200,
          headers: { ...corsHeaders, "Content-Type": "application/json" },
        }
      );
    }

    return new Response(JSON.stringify({ error: "Method not allowed" }), {
      status: 405,
      headers: { ...corsHeaders, "Content-Type": "application/json" },
    });
  } catch (e) {
    return new Response(JSON.stringify({ error: String(e) }), {
      status: 500,
      headers: { ...corsHeaders, "Content-Type": "application/json" },
    });
  }
});
