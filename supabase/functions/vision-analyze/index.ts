import { createClient } from "https://esm.sh/@supabase/supabase-js@2";

const corsHeaders = {
  "Access-Control-Allow-Origin": "*",
  "Access-Control-Allow-Headers":
    "authorization, x-client-info, apikey, content-type",
};

interface VisionFeature {
  type: string;
  maxResults?: number;
}

interface MatchedCategory {
  id: string;
  name: string;
  slug: string;
}

interface MatchedSubcategory extends MatchedCategory {
  category_id: string;
}

interface MatchedTag {
  id: string;
  name: string;
  slug: string;
}

function normalizeLabel(label: string): string {
  return label.toLowerCase().trim().replace(/[^a-z0-9\s]/g, "");
}

function findBestCategory(
  labels: string[],
  categories: MatchedCategory[]
): MatchedCategory | null {
  const normalized = labels.map(normalizeLabel);

  // Exact match first
  for (const cat of categories) {
    const catNorm = normalizeLabel(cat.name);
    if (normalized.includes(catNorm)) return cat;
  }

  // Partial match (label contains category name or vice versa)
  for (const cat of categories) {
    const catNorm = normalizeLabel(cat.name);
    for (const label of normalized) {
      if (label.includes(catNorm) || catNorm.includes(label)) return cat;
    }
  }

  return null;
}

function findBestSubcategory(
  labels: string[],
  subcategories: MatchedSubcategory[],
  categoryId: string | null
): MatchedSubcategory | null {
  const filtered = categoryId
    ? subcategories.filter((s) => s.category_id === categoryId)
    : subcategories;

  const normalized = labels.map(normalizeLabel);

  for (const sub of filtered) {
    const subNorm = normalizeLabel(sub.name);
    if (normalized.includes(subNorm)) return sub;
  }

  for (const sub of filtered) {
    const subNorm = normalizeLabel(sub.name);
    for (const label of normalized) {
      if (label.includes(subNorm) || subNorm.includes(label)) return sub;
    }
  }

  return null;
}

function findMatchingTags(
  labels: string[],
  tags: MatchedTag[],
  maxTags = 10
): MatchedTag[] {
  const matched: MatchedTag[] = [];
  const normalized = labels.map(normalizeLabel);
  const usedIds = new Set<string>();

  for (const tag of tags) {
    if (matched.length >= maxTags) break;
    const tagNorm = normalizeLabel(tag.name);
    for (const label of normalized) {
      if (
        !usedIds.has(tag.id) &&
        (label.includes(tagNorm) || tagNorm.includes(label))
      ) {
        matched.push(tag);
        usedIds.add(tag.id);
        break;
      }
    }
  }

  return matched;
}

function buildSuggestedTitle(
  webBestGuess: string | null,
  objectLabels: string[],
  ocrText: string | null
): string {
  // Prefer web detection best guess
  if (webBestGuess) return webBestGuess;

  // Try to build from OCR (first line often has brand/model)
  if (ocrText) {
    const firstLine = ocrText.split("\n")[0].trim();
    if (firstLine.length >= 3 && firstLine.length <= 100) return firstLine;
  }

  // Fall back to top object labels
  if (objectLabels.length > 0) {
    return objectLabels.slice(0, 3).join(" ");
  }

  return "";
}

function buildSuggestedDescription(
  labels: string[],
  ocrText: string | null
): string {
  const parts: string[] = [];

  if (labels.length > 0) {
    parts.push(labels.slice(0, 8).join(", "));
  }

  if (ocrText) {
    const cleaned = ocrText.replace(/\n+/g, " ").trim();
    if (cleaned.length > 0) {
      parts.push(cleaned.substring(0, 300));
    }
  }

  return parts.join(". ");
}

Deno.serve(async (req) => {
  if (req.method === "OPTIONS") {
    return new Response("ok", { headers: corsHeaders });
  }

  try {
    // Verify authentication
    const authHeader = req.headers.get("authorization");
    if (!authHeader) {
      return new Response(JSON.stringify({ error: "Missing authorization" }), {
        status: 401,
        headers: { ...corsHeaders, "Content-Type": "application/json" },
      });
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

    // Parse request body
    const { image } = await req.json();

    if (!image || typeof image !== "string") {
      return new Response(
        JSON.stringify({ error: "Missing 'image' (base64)" }),
        {
          status: 400,
          headers: { ...corsHeaders, "Content-Type": "application/json" },
        }
      );
    }

    // Call Google Cloud Vision API
    const apiKey = Deno.env.get("GOOGLE_VISION_API_KEY");
    if (!apiKey) {
      return new Response(
        JSON.stringify({ error: "Vision API not configured" }),
        {
          status: 500,
          headers: { ...corsHeaders, "Content-Type": "application/json" },
        }
      );
    }

    const features: VisionFeature[] = [
      { type: "LABEL_DETECTION", maxResults: 15 },
      { type: "OBJECT_LOCALIZATION", maxResults: 5 },
      { type: "TEXT_DETECTION", maxResults: 1 },
      { type: "WEB_DETECTION", maxResults: 5 },
    ];

    const visionResponse = await fetch(
      `https://vision.googleapis.com/v1/images:annotate?key=${apiKey}`,
      {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({
          requests: [
            {
              image: { content: image },
              features,
            },
          ],
        }),
      }
    );

    if (!visionResponse.ok) {
      const errText = await visionResponse.text();
      return new Response(
        JSON.stringify({ error: "Vision API error", details: errText }),
        {
          status: 502,
          headers: { ...corsHeaders, "Content-Type": "application/json" },
        }
      );
    }

    const visionData = await visionResponse.json();
    const result = visionData.responses?.[0];

    if (!result) {
      return new Response(
        JSON.stringify({ error: "No results from Vision API" }),
        {
          status: 422,
          headers: { ...corsHeaders, "Content-Type": "application/json" },
        }
      );
    }

    // Extract Vision API results
    const labelAnnotations = result.labelAnnotations ?? [];
    const objectAnnotations = result.localizedObjectAnnotations ?? [];
    const textAnnotations = result.textAnnotations ?? [];
    const webDetection = result.webDetection ?? {};

    const labels: string[] = labelAnnotations.map(
      (l: { description: string }) => l.description
    );
    const objectLabels: string[] = objectAnnotations.map(
      (o: { name: string }) => o.name
    );
    const allLabels = [...new Set([...objectLabels, ...labels])];

    const ocrText: string | null =
      textAnnotations.length > 0
        ? textAnnotations[0].description ?? null
        : null;

    const webBestGuess: string | null =
      webDetection.bestGuessLabels?.length > 0
        ? webDetection.bestGuessLabels[0].label ?? null
        : null;

    const topConfidence: number =
      labelAnnotations.length > 0 ? labelAnnotations[0].score ?? 0 : 0;

    // Load categories, subcategories, and tags from DB for matching
    const [categoriesRes, subcategoriesRes, tagsRes] = await Promise.all([
      supabase
        .from("categories")
        .select("id, name, slug")
        .eq("is_active", true),
      supabase
        .from("subcategories")
        .select("id, name, slug, category_id")
        .eq("is_active", true),
      supabase.from("tags").select("id, name, slug").order("usage_count", {
        ascending: false,
      }),
    ]);

    const categories: MatchedCategory[] = categoriesRes.data ?? [];
    const subcategories: MatchedSubcategory[] = subcategoriesRes.data ?? [];
    const tags: MatchedTag[] = tagsRes.data ?? [];

    // Match labels to app taxonomy
    const matchedCategory = findBestCategory(allLabels, categories);
    const matchedSubcategory = findBestSubcategory(
      allLabels,
      subcategories,
      matchedCategory?.id ?? null
    );
    const matchedTags = findMatchingTags(allLabels, tags);

    const suggestedTitle = buildSuggestedTitle(
      webBestGuess,
      objectLabels,
      ocrText
    );
    const suggestedDescription = buildSuggestedDescription(allLabels, ocrText);

    const response = {
      suggestedTitle,
      suggestedDescription,
      categoryId: matchedCategory?.id ?? null,
      categoryName: matchedCategory?.name ?? null,
      subcategoryId: matchedSubcategory?.id ?? null,
      subcategoryName: matchedSubcategory?.name ?? null,
      suggestedTags: matchedTags.map((t) => ({
        id: t.id,
        name: t.name,
        slug: t.slug,
      })),
      labels: allLabels,
      detectedText: ocrText,
      confidence: topConfidence,
    };

    return new Response(JSON.stringify(response), {
      status: 200,
      headers: { ...corsHeaders, "Content-Type": "application/json" },
    });
  } catch (error) {
    return new Response(JSON.stringify({ error: error.message }), {
      status: 500,
      headers: { ...corsHeaders, "Content-Type": "application/json" },
    });
  }
});
