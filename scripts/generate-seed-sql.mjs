import { readFile, writeFile } from "node:fs/promises";
import { dirname, resolve } from "node:path";
import { fileURLToPath } from "node:url";

const root = resolve(dirname(fileURLToPath(import.meta.url)), "..");

const readJson = async (path) => JSON.parse(await readFile(resolve(root, path), "utf8"));

const sqlString = (value) => {
  if (value === undefined || value === null || value === "") return "NULL";
  return `'${String(value).replaceAll("'", "''")}'`;
};

const sqlJson = (value) => `'${JSON.stringify(value).replaceAll("'", "''")}'::jsonb`;

const slugify = (value) =>
  String(value)
    .normalize("NFKD")
    .replace(/[\u0300-\u036f]/g, "")
    .toLowerCase()
    .replace(/[^a-z0-9]+/g, "-")
    .replace(/^-|-$/g, "");

const rows = [];
const counts = {};

const add = (sql) => rows.push(sql);

const motorcycles = await readJson("src/data/motorcycles/de-list.json");
const gsxSeatOptions = await readJson("src/data/products/gsx-s1000gx-seat-options.json");
const bmwSeatOptions = await readJson("src/data/products/bmw-seat-options.json");
const solutionPaths = await readJson("src/data/solution-paths/seat-comfort.json");
const productCategories = await readJson("src/data/product-categories/seat-comfort.json");
const sources = await readJson("src/data/sources/suzuki-gsx-s1000gx.json");
const countryProfile = await readJson("src/data/country-profiles/de.json");
const technicalProfiles = await readJson("src/data/motorcycles/technical-profiles.json");
const seatMaterials = await readJson("src/data/materials/seat-materials.json");
const workshopTools = await readJson("src/data/tools/seat-tools.json");
const workshopSupplies = await readJson("src/data/supplies/seat-supplies.json");
const buyingChannels = await readJson("src/data/marketplaces/de.json");
const mediaAssets = await readJson("src/data/media/media-assets.json");
const videoResources = await readJson("src/data/videos/seat-videos.json");
const countryName = countryProfile.name || (countryProfile.country === "DE" ? "Deutschland" : countryProfile.country);
const seatOptions = [
  ...gsxSeatOptions.map((option) => ({
    ...option,
    motorcycleSlug: "suzuki-gsx-s1000gx",
  })),
  ...bmwSeatOptions.flatMap((option) =>
    (option.motorcycleSlugs || ["bmw-r-1300-gs"]).map((motorcycleSlug) => ({
      ...option,
      key: option.motorcycleSlugs?.length > 1 ? `${option.key}-${motorcycleSlug}` : option.key,
      originalKey: option.key,
      motorcycleSlug,
    }))
  ),
];

add("BEGIN;");

add(`INSERT INTO countries (code, name, language_code, market_notes, source_data, updated_at)
VALUES (
  'de',
  ${sqlString(countryName)},
  ${sqlString(countryProfile.language || "de")},
  ${sqlString(countryProfile.marketNotes || countryProfile.notes || "German pilot market")},
  ${sqlJson(countryProfile)},
  now()
)
ON CONFLICT (code) DO UPDATE SET
  name = EXCLUDED.name,
  language_code = EXCLUDED.language_code,
  market_notes = EXCLUDED.market_notes,
  source_data = EXCLUDED.source_data,
  updated_at = now();`);
counts.countries = 1;

for (const motorcycle of motorcycles) {
  const slug = slugify(motorcycle.name);
  add(`INSERT INTO motorcycles (
    slug, brand, model, segment, country_priority, status, guide_path,
    seat_pain_focus, why_next, source_data, updated_at
  )
  VALUES (
    ${sqlString(slug)},
    ${sqlString(motorcycle.brand)},
    ${sqlString(motorcycle.name)},
    ${sqlString(motorcycle.segment)},
    ${sqlString(motorcycle.countryPriority)},
    ${sqlString(motorcycle.status)},
    ${sqlString(motorcycle.path)},
    ${sqlString(motorcycle.seatPainFocus)},
    ${sqlString(motorcycle.whyNext)},
    ${sqlJson({ ...motorcycle, slug })},
    now()
  )
  ON CONFLICT (slug) DO UPDATE SET
    brand = EXCLUDED.brand,
    model = EXCLUDED.model,
    segment = EXCLUDED.segment,
    country_priority = EXCLUDED.country_priority,
    status = EXCLUDED.status,
    guide_path = EXCLUDED.guide_path,
    seat_pain_focus = EXCLUDED.seat_pain_focus,
    why_next = EXCLUDED.why_next,
    source_data = EXCLUDED.source_data,
    updated_at = now();`);
}
counts.motorcycles = motorcycles.length;

for (const path of solutionPaths) {
  add(`INSERT INTO solution_paths (
    key, title, summary, best_for, not_ideal_for, cost, confidence, source_data, updated_at
  )
  VALUES (
    ${sqlString(path.key)},
    ${sqlString(path.title)},
    ${sqlString(path.summary)},
    ${sqlString(path.bestFor)},
    ${sqlString(path.notIdealFor)},
    ${sqlString(path.cost)},
    ${sqlString(path.confidence)},
    ${sqlJson(path)},
    now()
  )
  ON CONFLICT (key) DO UPDATE SET
    title = EXCLUDED.title,
    summary = EXCLUDED.summary,
    best_for = EXCLUDED.best_for,
    not_ideal_for = EXCLUDED.not_ideal_for,
    cost = EXCLUDED.cost,
    confidence = EXCLUDED.confidence,
    source_data = EXCLUDED.source_data,
    updated_at = now();`);
}
counts.solution_paths = solutionPaths.length;

for (const category of productCategories) {
  add(`INSERT INTO product_categories (
    key, name, problem_solved, limitations, price_band, first_test,
    avoid_when, buying_checks, affiliate_status, source_data, updated_at
  )
  VALUES (
    ${sqlString(category.key)},
    ${sqlString(category.name)},
    ${sqlString(category.problemSolved)},
    ${sqlString(category.limitations)},
    ${sqlString(category.priceBand)},
    ${sqlString(category.firstTest)},
    ${sqlString(category.avoidWhen)},
    ${sqlJson(category.buyingChecks || [])},
    ${sqlString(category.affiliateStatus)},
    ${sqlJson(category)},
    now()
  )
  ON CONFLICT (key) DO UPDATE SET
    name = EXCLUDED.name,
    problem_solved = EXCLUDED.problem_solved,
    limitations = EXCLUDED.limitations,
    price_band = EXCLUDED.price_band,
    first_test = EXCLUDED.first_test,
    avoid_when = EXCLUDED.avoid_when,
    buying_checks = EXCLUDED.buying_checks,
    affiliate_status = EXCLUDED.affiliate_status,
    source_data = EXCLUDED.source_data,
    updated_at = now();`);
}
counts.product_categories = productCategories.length;

for (const option of seatOptions) {
  add(`INSERT INTO seat_options (
    key, motorcycle_slug, name, maker, option_type, fitment, market, price_note,
    best_for, watch_out, comfort_logic, research_status, confidence,
    affiliate_status, image_path, image_alt, source_label, source_url, source_data, updated_at
  )
  VALUES (
    ${sqlString(option.key)},
    ${sqlString(option.motorcycleSlug)},
    ${sqlString(option.name)},
    ${sqlString(option.maker)},
    ${sqlString(option.type)},
    ${sqlString(option.fitment)},
    ${sqlString(option.market)},
    ${sqlString(option.priceNote)},
    ${sqlString(option.bestFor)},
    ${sqlString(option.watchOut)},
    ${sqlString(option.comfortLogic)},
    ${sqlString(option.researchStatus)},
    ${option.confidence ?? "NULL"},
    ${sqlString(option.affiliateStatus)},
    ${sqlString(option.imagePath)},
    ${sqlString(option.imageAlt)},
    ${sqlString(option.sourceLabel)},
    ${sqlString(option.sourceUrl)},
    ${sqlJson(option)},
    now()
  )
  ON CONFLICT (key) DO UPDATE SET
    motorcycle_slug = EXCLUDED.motorcycle_slug,
    name = EXCLUDED.name,
    maker = EXCLUDED.maker,
    option_type = EXCLUDED.option_type,
    fitment = EXCLUDED.fitment,
    market = EXCLUDED.market,
    price_note = EXCLUDED.price_note,
    best_for = EXCLUDED.best_for,
    watch_out = EXCLUDED.watch_out,
    comfort_logic = EXCLUDED.comfort_logic,
    research_status = EXCLUDED.research_status,
    confidence = EXCLUDED.confidence,
    affiliate_status = EXCLUDED.affiliate_status,
    image_path = EXCLUDED.image_path,
    image_alt = EXCLUDED.image_alt,
    source_label = EXCLUDED.source_label,
    source_url = EXCLUDED.source_url,
    source_data = EXCLUDED.source_data,
    updated_at = now();`);
}
counts.seat_options = seatOptions.length;

add("DELETE FROM research_sources WHERE motorcycle_slug = 'suzuki-gsx-s1000gx';");
for (const source of sources) {
  add(`INSERT INTO research_sources (
    motorcycle_slug, title, url, notes, confidence, source_data, updated_at
  )
  VALUES (
    'suzuki-gsx-s1000gx',
    ${sqlString(source.title)},
    ${sqlString(source.url)},
    ${sqlString(source.notes)},
    ${source.confidence ?? "NULL"},
    ${sqlJson(source)},
    now()
  );`);
}
counts.research_sources = sources.length;

for (const profile of technicalProfiles) {
  add(`INSERT INTO motorcycle_technical_profiles (
    motorcycle_slug, seat_height_mm, wet_weight_kg, riding_triangle_status,
    usage_profile, seat_comfort_risks, required_measurements, notes, source_data, updated_at
  )
  VALUES (
    ${sqlString(profile.motorcycleSlug)},
    ${profile.seatHeightMm ?? "NULL"},
    ${profile.wetWeightKg ?? "NULL"},
    ${sqlString(profile.ridingTriangleStatus)},
    ${sqlJson(profile.usageProfile || [])},
    ${sqlJson(profile.seatComfortRisks || [])},
    ${sqlJson(profile.requiredMeasurements || [])},
    ${sqlString(profile.notes)},
    ${sqlJson(profile)},
    now()
  )
  ON CONFLICT (motorcycle_slug) DO UPDATE SET
    seat_height_mm = EXCLUDED.seat_height_mm,
    wet_weight_kg = EXCLUDED.wet_weight_kg,
    riding_triangle_status = EXCLUDED.riding_triangle_status,
    usage_profile = EXCLUDED.usage_profile,
    seat_comfort_risks = EXCLUDED.seat_comfort_risks,
    required_measurements = EXCLUDED.required_measurements,
    notes = EXCLUDED.notes,
    source_data = EXCLUDED.source_data,
    updated_at = now();`);
}
counts.technical_profiles = technicalProfiles.length;

for (const material of seatMaterials) {
  add(`INSERT INTO seat_materials (
    key, name, material_type, comfort_role, best_for, avoid_when,
    skill_level, price_band, durability_notes, research_status, source_data, updated_at
  )
  VALUES (
    ${sqlString(material.key)},
    ${sqlString(material.name)},
    ${sqlString(material.materialType)},
    ${sqlString(material.comfortRole)},
    ${sqlString(material.bestFor)},
    ${sqlString(material.avoidWhen)},
    ${sqlString(material.skillLevel)},
    ${sqlString(material.priceBand)},
    ${sqlString(material.durabilityNotes)},
    ${sqlString(material.researchStatus)},
    ${sqlJson(material)},
    now()
  )
  ON CONFLICT (key) DO UPDATE SET
    name = EXCLUDED.name,
    material_type = EXCLUDED.material_type,
    comfort_role = EXCLUDED.comfort_role,
    best_for = EXCLUDED.best_for,
    avoid_when = EXCLUDED.avoid_when,
    skill_level = EXCLUDED.skill_level,
    price_band = EXCLUDED.price_band,
    durability_notes = EXCLUDED.durability_notes,
    research_status = EXCLUDED.research_status,
    source_data = EXCLUDED.source_data,
    updated_at = now();`);
}
counts.seat_materials = seatMaterials.length;

for (const tool of workshopTools) {
  add(`INSERT INTO workshop_tools (
    key, name, tool_type, skill_level, used_for, risk_notes, buying_notes, source_data, updated_at
  )
  VALUES (
    ${sqlString(tool.key)},
    ${sqlString(tool.name)},
    ${sqlString(tool.toolType)},
    ${sqlString(tool.skillLevel)},
    ${sqlString(tool.usedFor)},
    ${sqlString(tool.riskNotes)},
    ${sqlString(tool.buyingNotes)},
    ${sqlJson(tool)},
    now()
  )
  ON CONFLICT (key) DO UPDATE SET
    name = EXCLUDED.name,
    tool_type = EXCLUDED.tool_type,
    skill_level = EXCLUDED.skill_level,
    used_for = EXCLUDED.used_for,
    risk_notes = EXCLUDED.risk_notes,
    buying_notes = EXCLUDED.buying_notes,
    source_data = EXCLUDED.source_data,
    updated_at = now();`);
}
counts.workshop_tools = workshopTools.length;

for (const supply of workshopSupplies) {
  add(`INSERT INTO workshop_supplies (
    key, name, supply_type, skill_level, used_for, best_for, risk_notes,
    buying_notes, source_data, updated_at
  )
  VALUES (
    ${sqlString(supply.key)},
    ${sqlString(supply.name)},
    ${sqlString(supply.supplyType)},
    ${sqlString(supply.skillLevel)},
    ${sqlString(supply.usedFor)},
    ${sqlString(supply.bestFor)},
    ${sqlString(supply.riskNotes)},
    ${sqlString(supply.buyingNotes)},
    ${sqlJson(supply)},
    now()
  )
  ON CONFLICT (key) DO UPDATE SET
    name = EXCLUDED.name,
    supply_type = EXCLUDED.supply_type,
    skill_level = EXCLUDED.skill_level,
    used_for = EXCLUDED.used_for,
    best_for = EXCLUDED.best_for,
    risk_notes = EXCLUDED.risk_notes,
    buying_notes = EXCLUDED.buying_notes,
    source_data = EXCLUDED.source_data,
    updated_at = now();`);
}
counts.workshop_supplies = workshopSupplies.length;

for (const channel of buyingChannels) {
  add(`INSERT INTO buying_channels (
    key, name, channel_type, country_code, best_for, affiliate_potential,
    trust_level, notes, source_data, updated_at
  )
  VALUES (
    ${sqlString(channel.key)},
    ${sqlString(channel.name)},
    ${sqlString(channel.channelType)},
    ${sqlString((channel.country || "DE").toLowerCase())},
    ${sqlString(channel.bestFor)},
    ${sqlString(channel.affiliatePotential)},
    ${channel.trustLevel ?? "NULL"},
    ${sqlString(channel.notes)},
    ${sqlJson(channel)},
    now()
  )
  ON CONFLICT (key) DO UPDATE SET
    name = EXCLUDED.name,
    channel_type = EXCLUDED.channel_type,
    country_code = EXCLUDED.country_code,
    best_for = EXCLUDED.best_for,
    affiliate_potential = EXCLUDED.affiliate_potential,
    trust_level = EXCLUDED.trust_level,
    notes = EXCLUDED.notes,
    source_data = EXCLUDED.source_data,
    updated_at = now();`);
}
counts.buying_channels = buyingChannels.length;

add("DELETE FROM content_media_links;");
for (const asset of mediaAssets) {
  add(`INSERT INTO media_assets (
    key, title, description, local_path, download_url, source_page_url,
    source_name, creator, license_name, license_code, license_url, rights_status,
    attribution_required, share_alike_required, modification_allowed,
    commercial_use_allowed, endorsement_warning, credit_line, alt, caption,
    dominant_color, aspect_ratio, object_position, recommended_usage, notes, status,
    source_data, updated_at
  )
  VALUES (
    ${sqlString(asset.key)},
    ${sqlString(asset.title)},
    ${sqlString(asset.description)},
    ${sqlString(asset.localPath)},
    ${sqlString(asset.downloadUrl)},
    ${sqlString(asset.sourcePageUrl)},
    ${sqlString(asset.sourceName)},
    ${sqlString(asset.creator)},
    ${sqlString(asset.licenseName)},
    ${sqlString(asset.licenseCode)},
    ${sqlString(asset.licenseUrl)},
    ${sqlString(asset.rightsStatus)},
    ${asset.attributionRequired ? "true" : "false"},
    ${asset.shareAlikeRequired ? "true" : "false"},
    ${asset.modificationAllowed ? "true" : "false"},
    ${asset.commercialUseAllowed ? "true" : "false"},
    ${asset.endorsementWarning === false ? "false" : "true"},
    ${sqlString(asset.creditLine)},
    ${sqlString(asset.alt)},
    ${sqlString(asset.caption)},
    ${sqlString(asset.dominantColor)},
    ${sqlString(asset.aspectRatio)},
    ${sqlString(asset.objectPosition)},
    ${sqlJson(asset.recommendedUsage || [])},
    ${sqlString(asset.notes)},
    ${sqlString(asset.status || "active")},
    ${sqlJson(asset)},
    now()
  )
  ON CONFLICT (key) DO UPDATE SET
    title = EXCLUDED.title,
    description = EXCLUDED.description,
    local_path = EXCLUDED.local_path,
    download_url = EXCLUDED.download_url,
    source_page_url = EXCLUDED.source_page_url,
    source_name = EXCLUDED.source_name,
    creator = EXCLUDED.creator,
    license_name = EXCLUDED.license_name,
    license_code = EXCLUDED.license_code,
    license_url = EXCLUDED.license_url,
    rights_status = EXCLUDED.rights_status,
    attribution_required = EXCLUDED.attribution_required,
    share_alike_required = EXCLUDED.share_alike_required,
    modification_allowed = EXCLUDED.modification_allowed,
    commercial_use_allowed = EXCLUDED.commercial_use_allowed,
    endorsement_warning = EXCLUDED.endorsement_warning,
    credit_line = EXCLUDED.credit_line,
    alt = EXCLUDED.alt,
    caption = EXCLUDED.caption,
    dominant_color = EXCLUDED.dominant_color,
    aspect_ratio = EXCLUDED.aspect_ratio,
    object_position = EXCLUDED.object_position,
    recommended_usage = EXCLUDED.recommended_usage,
    notes = EXCLUDED.notes,
    status = EXCLUDED.status,
    source_data = EXCLUDED.source_data,
    updated_at = now();`);

  for (const link of asset.links || []) {
    add(`INSERT INTO content_media_links (
      media_key, entity_type, entity_key, usage, priority
    )
    VALUES (
      ${sqlString(asset.key)},
      ${sqlString(link.entityType)},
      ${sqlString(link.entityKey)},
      ${sqlString(link.usage || "card")},
      ${link.priority ?? 10}
    )
    ON CONFLICT (media_key, entity_type, entity_key, usage) DO UPDATE SET
      priority = EXCLUDED.priority;`);
  }
}
counts.media_assets = mediaAssets.length;
counts.content_media_links = mediaAssets.reduce((sum, asset) => sum + (asset.links || []).length, 0);

add("DELETE FROM content_video_links;");
add("DELETE FROM video_resources;");
for (const video of videoResources) {
  const embedUrl = video.youtubeVideoId
    ? `https://www.youtube-nocookie.com/embed/${video.youtubeVideoId}?rel=0&modestbranding=1&playsinline=1`
    : null;
  const providerUrl = video.providerUrl || video.youtubeUrl || video.sourcePageUrl;
  add(`INSERT INTO video_resources (
    key, status, topic, provider, provider_video_id, provider_url, embed_url,
    source_page_url, title, channel_name, language_code, duration, thumbnail_url,
    fetched_description, editor_summary, what_to_look_for, fit_for, risk_notes,
    embed_policy, source_data, updated_at
  )
  VALUES (
    ${sqlString(video.key)},
    ${sqlString(video.status || "curation_needed")},
    ${sqlString(video.topic)},
    'youtube',
    ${sqlString(video.youtubeVideoId)},
    ${sqlString(providerUrl)},
    ${sqlString(embedUrl)},
    ${sqlString(video.sourcePageUrl)},
    ${sqlString(video.title)},
    ${sqlString(video.channelName)},
    ${sqlString(video.language)},
    ${sqlString(video.duration)},
    ${sqlString(video.thumbnailUrl)},
    ${sqlString(video.fetchedDescription)},
    ${sqlString(video.editorSummary)},
    ${sqlJson(video.whatToLookFor || [])},
    ${sqlJson(video.fitFor || [])},
    ${sqlString(video.riskNotes)},
    ${sqlString(video.embedPolicy)},
    ${sqlJson(video)},
    now()
  )
  ON CONFLICT (key) DO UPDATE SET
    status = EXCLUDED.status,
    topic = EXCLUDED.topic,
    provider = EXCLUDED.provider,
    provider_video_id = EXCLUDED.provider_video_id,
    provider_url = EXCLUDED.provider_url,
    embed_url = EXCLUDED.embed_url,
    source_page_url = EXCLUDED.source_page_url,
    title = EXCLUDED.title,
    channel_name = EXCLUDED.channel_name,
    language_code = EXCLUDED.language_code,
    duration = EXCLUDED.duration,
    thumbnail_url = EXCLUDED.thumbnail_url,
    fetched_description = EXCLUDED.fetched_description,
    editor_summary = EXCLUDED.editor_summary,
    what_to_look_for = EXCLUDED.what_to_look_for,
    fit_for = EXCLUDED.fit_for,
    risk_notes = EXCLUDED.risk_notes,
    embed_policy = EXCLUDED.embed_policy,
    source_data = EXCLUDED.source_data,
    updated_at = now();`);

  for (const link of video.links || []) {
    add(`INSERT INTO content_video_links (
      video_key, entity_type, entity_key, usage, priority, notes
    )
    VALUES (
      ${sqlString(video.key)},
      ${sqlString(link.entityType)},
      ${sqlString(link.entityKey)},
      ${sqlString(link.usage || "learning")},
      ${link.priority ?? 10},
      ${sqlString(link.notes)}
    )
    ON CONFLICT (video_key, entity_type, entity_key, usage) DO UPDATE SET
      priority = EXCLUDED.priority,
      notes = EXCLUDED.notes;`);
  }
}
counts.video_resources = videoResources.length;
counts.content_video_links = videoResources.reduce((sum, video) => sum + (video.links || []).length, 0);

add(`INSERT INTO import_runs (label, row_counts)
VALUES ('json seed import', ${sqlJson(counts)});`);

add("COMMIT;");

const output = [
  "-- Generated by scripts/generate-seed-sql.mjs. Do not edit by hand.",
  "-- Re-run `make db-seed` after changing JSON source data.",
  "",
  ...rows,
  ""
].join("\n");

await writeFile(resolve(root, "db/seed.generated.sql"), output, "utf8");
console.log(`Generated db/seed.generated.sql with ${Object.values(counts).reduce((sum, value) => sum + value, 0)} seeded rows.`);
