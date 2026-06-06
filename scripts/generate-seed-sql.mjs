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
const seatCatalog = await readJson("src/data/products/seat-catalog.json");
const solutionPaths = await readJson("src/data/solution-paths/seat-comfort.json");
const productCategories = await readJson("src/data/product-categories/seat-comfort.json");
const sources = await readJson("src/data/sources/suzuki-gsx-s1000gx.json");
const countries = await readJson("src/data/i18n/countries.json");
const uiCopy = await readJson("src/data/i18n/ui-copy.json");
const localizedHome = await readJson("src/data/i18n/localized-home.json");
const countrySeatIntelligence = await readJson("src/data/country-seat-intelligence.json");
const technicalProfiles = await readJson("src/data/motorcycles/technical-profiles.json");
const seatMaterials = await readJson("src/data/materials/seat-materials.json");
const workshopTools = await readJson("src/data/tools/seat-tools.json");
const workshopSupplies = await readJson("src/data/supplies/seat-supplies.json");
const buyingChannels = await readJson("src/data/marketplaces/de.json");
const mediaAssets = await readJson("src/data/media/media-assets.json");
const videoResources = await readJson("src/data/videos/seat-videos.json");
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

const languageMeta = {
  de: { name: "German", nativeName: "Deutsch", status: "active" },
  sk: { name: "Slovak", nativeName: "Slovenčina", status: "draft" },
  en: { name: "English", nativeName: "English", status: "draft" },
  fr: { name: "French", nativeName: "Français", status: "planned" },
  it: { name: "Italian", nativeName: "Italiano", status: "planned" },
  hu: { name: "Hungarian", nativeName: "Magyar", status: "planned" },
  pl: { name: "Polish", nativeName: "Polski", status: "planned" },
  ru: { name: "Russian", nativeName: "Русский", status: "planned" },
  tr: { name: "Turkish", nativeName: "Türkçe", status: "planned" },
  th: { name: "Thai", nativeName: "ไทย", status: "planned" },
  id: { name: "Indonesian", nativeName: "Bahasa Indonesia", status: "planned" },
  ms: { name: "Malay", nativeName: "Bahasa Melayu", status: "planned" },
  zh: { name: "Chinese", nativeName: "中文", status: "planned" },
};

const languageCodes = Array.from(
  new Set([...countries.flatMap((country) => country.languages || []), ...Object.keys(uiCopy)])
).sort();

add("BEGIN;");

add("DELETE FROM ui_translations;");
add("DELETE FROM localized_pages;");
add("DELETE FROM country_languages;");

for (const code of languageCodes) {
  const meta = languageMeta[code] || { name: code.toUpperCase(), nativeName: code.toUpperCase(), status: "planned" };
  add(`INSERT INTO languages (
    code, name, native_name, status, source_data, updated_at
  )
  VALUES (
    ${sqlString(code)},
    ${sqlString(meta.name)},
    ${sqlString(meta.nativeName)},
    ${sqlString(meta.status)},
    ${sqlJson({ code, ...meta })},
    now()
  )
  ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    native_name = EXCLUDED.native_name,
    status = EXCLUDED.status,
    source_data = EXCLUDED.source_data,
    updated_at = now();`);
}
counts.languages = languageCodes.length;

for (const country of countries) {
  add(`INSERT INTO countries (
    code, slug, flag_emoji, name, native_name, language_code, region, market_tier,
    currency_code, status, priority, market_notes, design_hints, content_focus,
    source_data, updated_at
  )
  VALUES (
    ${sqlString(country.code)},
    ${sqlString(country.slug)},
    ${sqlString(country.flagEmoji)},
    ${sqlString(country.name)},
    ${sqlString(country.nativeName)},
    ${sqlString(country.primaryLanguage)},
    ${sqlString(country.region)},
    ${sqlString(country.marketTier)},
    ${sqlString(country.currency)},
    ${sqlString(country.status)},
    ${country.priority ?? 100},
    ${sqlString(country.seatStrategy || country.notes)},
    ${sqlJson(country.designHints || {})},
    ${sqlJson(country.contentFocus || [])},
    ${sqlJson(country)},
    now()
  )
  ON CONFLICT (code) DO UPDATE SET
    slug = EXCLUDED.slug,
    flag_emoji = EXCLUDED.flag_emoji,
    name = EXCLUDED.name,
    native_name = EXCLUDED.native_name,
    language_code = EXCLUDED.language_code,
    region = EXCLUDED.region,
    market_tier = EXCLUDED.market_tier,
    currency_code = EXCLUDED.currency_code,
    status = EXCLUDED.status,
    priority = EXCLUDED.priority,
    market_notes = EXCLUDED.market_notes,
    design_hints = EXCLUDED.design_hints,
    content_focus = EXCLUDED.content_focus,
    source_data = EXCLUDED.source_data,
    updated_at = now();`);

  for (const [index, languageCode] of (country.languages || [country.primaryLanguage]).entries()) {
    add(`INSERT INTO country_languages (
      country_code, language_code, is_primary, priority, source_data
    )
    VALUES (
      ${sqlString(country.code)},
      ${sqlString(languageCode)},
      ${languageCode === country.primaryLanguage ? "true" : "false"},
      ${index + 1},
      ${sqlJson({ countryCode: country.code, languageCode, primaryLanguage: country.primaryLanguage })}
    )
    ON CONFLICT (country_code, language_code) DO UPDATE SET
      is_primary = EXCLUDED.is_primary,
      priority = EXCLUDED.priority,
      source_data = EXCLUDED.source_data;`);
  }
}
counts.countries = countries.length;
counts.country_languages = countries.reduce((sum, country) => sum + (country.languages || [country.primaryLanguage]).length, 0);

let translationCount = 0;
for (const [languageCode, translations] of Object.entries(uiCopy)) {
  for (const [key, value] of Object.entries(translations)) {
    translationCount += 1;
    add(`INSERT INTO ui_translations (
      language_code, translation_key, translation_value, status, source_data, updated_at
    )
    VALUES (
      ${sqlString(languageCode)},
      ${sqlString(key)},
      ${sqlString(value)},
      ${languageCode === "de" ? "'active'" : "'draft'"},
      ${sqlJson({ languageCode, key })},
      now()
    )
    ON CONFLICT (language_code, translation_key) DO UPDATE SET
      translation_value = EXCLUDED.translation_value,
      status = EXCLUDED.status,
      source_data = EXCLUDED.source_data,
      updated_at = now();`);
  }
}
counts.ui_translations = translationCount;

for (const country of countries.filter((country) => country.code !== "de")) {
  const page = localizedHome[country.code];
  if (!page) continue;
  add(`INSERT INTO localized_pages (
    country_code, language_code, page_key, route_path, title, description,
    status, content, source_data, updated_at
  )
  VALUES (
    ${sqlString(country.code)},
    ${sqlString(country.primaryLanguage)},
    'home',
    ${sqlString(country.defaultPath)},
    ${sqlString(page.title)},
    ${sqlString(page.description)},
    ${sqlString(country.status || "draft")},
    ${sqlJson(page)},
    ${sqlJson({ countryCode: country.code, languageCode: country.primaryLanguage, pageKey: "home" })},
    now()
  )
  ON CONFLICT (country_code, language_code, page_key) DO UPDATE SET
    route_path = EXCLUDED.route_path,
    title = EXCLUDED.title,
    description = EXCLUDED.description,
    status = EXCLUDED.status,
    content = EXCLUDED.content,
    source_data = EXCLUDED.source_data,
    updated_at = now();`);
}
counts.localized_pages = countries.filter((country) => country.code !== "de" && localizedHome[country.code]).length;

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

add("DELETE FROM seat_product_fitments;");
add("DELETE FROM seat_products;");
add("DELETE FROM seat_manufacturers;");
for (const manufacturer of seatCatalog.manufacturers) {
  add(`INSERT INTO seat_manufacturers (
    key, name, manufacturer_type, country, website, notes, source_data, updated_at
  )
  VALUES (
    ${sqlString(manufacturer.key)},
    ${sqlString(manufacturer.name)},
    ${sqlString(manufacturer.manufacturerType)},
    ${sqlString(manufacturer.country)},
    ${sqlString(manufacturer.website)},
    ${sqlString(manufacturer.notes)},
    ${sqlJson(manufacturer)},
    now()
  )
  ON CONFLICT (key) DO UPDATE SET
    name = EXCLUDED.name,
    manufacturer_type = EXCLUDED.manufacturer_type,
    country = EXCLUDED.country,
    website = EXCLUDED.website,
    notes = EXCLUDED.notes,
    source_data = EXCLUDED.source_data,
    updated_at = now();`);
}
counts.seat_manufacturers = seatCatalog.manufacturers.length;

for (const product of seatCatalog.products) {
  add(`INSERT INTO seat_products (
    key, manufacturer_key, name, product_type, status, price_band, price_note,
    comfort_claims, risks, colors, variants, source_label, source_url,
    source_checked_at, source_data, updated_at
  )
  VALUES (
    ${sqlString(product.key)},
    ${sqlString(product.manufacturerKey)},
    ${sqlString(product.name)},
    ${sqlString(product.productType)},
    ${sqlString(product.status)},
    ${sqlString(product.priceBand)},
    ${sqlString(product.priceNote)},
    ${sqlJson(product.comfortClaims || [])},
    ${sqlJson(product.risks || [])},
    ${sqlJson(product.colors || [])},
    ${sqlJson(product.variants || [])},
    ${sqlString(product.source?.label)},
    ${sqlString(product.source?.url)},
    ${sqlString(product.source?.checkedAt)},
    ${sqlJson(product)},
    now()
  )
  ON CONFLICT (key) DO UPDATE SET
    manufacturer_key = EXCLUDED.manufacturer_key,
    name = EXCLUDED.name,
    product_type = EXCLUDED.product_type,
    status = EXCLUDED.status,
    price_band = EXCLUDED.price_band,
    price_note = EXCLUDED.price_note,
    comfort_claims = EXCLUDED.comfort_claims,
    risks = EXCLUDED.risks,
    colors = EXCLUDED.colors,
    variants = EXCLUDED.variants,
    source_label = EXCLUDED.source_label,
    source_url = EXCLUDED.source_url,
    source_checked_at = EXCLUDED.source_checked_at,
    source_data = EXCLUDED.source_data,
    updated_at = now();`);

  for (const fitment of product.fitments || []) {
    add(`INSERT INTO seat_product_fitments (
      product_key, motorcycle_slug, brand, model, year_start, year_end,
      fitment_status, notes, source_data
    )
    VALUES (
      ${sqlString(product.key)},
      ${sqlString(fitment.motorcycleSlug)},
      ${sqlString(fitment.brand)},
      ${sqlString(fitment.model)},
      ${fitment.yearStart ?? "NULL"},
      ${fitment.yearEnd ?? "NULL"},
      ${sqlString(fitment.fitmentStatus)},
      ${sqlString(fitment.notes)},
      ${sqlJson(fitment)}
    )
    ON CONFLICT (product_key, motorcycle_slug, brand, model) DO UPDATE SET
      year_start = EXCLUDED.year_start,
      year_end = EXCLUDED.year_end,
      fitment_status = EXCLUDED.fitment_status,
      notes = EXCLUDED.notes,
      source_data = EXCLUDED.source_data;`);
  }
}
counts.seat_products = seatCatalog.products.length;
counts.seat_product_fitments = seatCatalog.products.reduce((sum, product) => sum + (product.fitments || []).length, 0);

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

add("DELETE FROM country_research_sources;");
for (const strategy of countrySeatIntelligence) {
  add(`INSERT INTO country_seat_strategies (
    country_code, priority, market_mode, lead_motorcycle_segments, lead_motorcycles,
    primary_pain_points, first_recommendation, budget_logic, buying_priorities,
    admin_notes, source_data, updated_at
  )
  VALUES (
    ${sqlString(strategy.countryCode)},
    ${strategy.priority ?? 100},
    ${sqlString(strategy.marketMode)},
    ${sqlJson(strategy.leadMotorcycleSegments || [])},
    ${sqlJson(strategy.leadMotorcycles || [])},
    ${sqlJson(strategy.primaryPainPoints || [])},
    ${sqlString(strategy.firstRecommendation)},
    ${sqlString(strategy.budgetLogic)},
    ${sqlJson(strategy.buyingPriorities || [])},
    ${sqlString(strategy.adminNotes)},
    ${sqlJson(strategy)},
    now()
  )
  ON CONFLICT (country_code) DO UPDATE SET
    priority = EXCLUDED.priority,
    market_mode = EXCLUDED.market_mode,
    lead_motorcycle_segments = EXCLUDED.lead_motorcycle_segments,
    lead_motorcycles = EXCLUDED.lead_motorcycles,
    primary_pain_points = EXCLUDED.primary_pain_points,
    first_recommendation = EXCLUDED.first_recommendation,
    budget_logic = EXCLUDED.budget_logic,
    buying_priorities = EXCLUDED.buying_priorities,
    admin_notes = EXCLUDED.admin_notes,
    source_data = EXCLUDED.source_data,
    updated_at = now();`);

  for (const [index, source] of (strategy.forumSources || []).entries()) {
    const key = `${strategy.countryCode}-${slugify(source.name)}-${index + 1}`;
    add(`INSERT INTO country_research_sources (
      key, country_code, name, url, language_code, source_type, note, status,
      source_data, updated_at
    )
    VALUES (
      ${sqlString(key)},
      ${sqlString(strategy.countryCode)},
      ${sqlString(source.name)},
      ${sqlString(source.url)},
      ${sqlString(source.language)},
      'forum',
      ${sqlString(source.note)},
      'active',
      ${sqlJson(source)},
      now()
    )
    ON CONFLICT (key) DO UPDATE SET
      country_code = EXCLUDED.country_code,
      name = EXCLUDED.name,
      url = EXCLUDED.url,
      language_code = EXCLUDED.language_code,
      source_type = EXCLUDED.source_type,
      note = EXCLUDED.note,
      status = EXCLUDED.status,
      source_data = EXCLUDED.source_data,
      updated_at = now();`);
  }
}
counts.country_seat_strategies = countrySeatIntelligence.length;
counts.country_research_sources = countrySeatIntelligence.reduce((sum, strategy) => sum + (strategy.forumSources || []).length, 0);

add("DELETE FROM content_media_links;");
add("DELETE FROM media_assets;");
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

const vocabularies = [
  {
    key: "record_status",
    name: "Record status",
    description: "Reusable status labels used by content and catalog tables.",
  },
  {
    key: "motorcycle_segment",
    name: "Motorcycle segment",
    description: "High-level motorcycle categories for filtering and advice.",
  },
  {
    key: "seat_option_type",
    name: "Seat option type",
    description: "Commercial and DIY option classes for seat comfort advice.",
  },
  {
    key: "product_type",
    name: "Product type",
    description: "Manufacturer product classes.",
  },
  {
    key: "media_entity_type",
    name: "Media entity type",
    description: "Entity keys used by content_media_links.",
  },
  {
    key: "video_entity_type",
    name: "Video entity type",
    description: "Entity keys used by content_video_links.",
  },
];

for (const vocabulary of vocabularies) {
  add(`INSERT INTO controlled_vocabularies (
    key, name, description, join_policy, updated_at
  )
  VALUES (
    ${sqlString(vocabulary.key)},
    ${sqlString(vocabulary.name)},
    ${sqlString(vocabulary.description)},
    'optional_reference',
    now()
  )
  ON CONFLICT (key) DO UPDATE SET
    name = EXCLUDED.name,
    description = EXCLUDED.description,
    join_policy = EXCLUDED.join_policy,
    updated_at = now();`);
}

const vocabularyTerms = new Map();
const addVocabularyTerm = (vocabularyKey, termKey, sourceTable) => {
  if (!termKey) return;
  const key = `${vocabularyKey}:${termKey}`;
  const current = vocabularyTerms.get(key) || {
    vocabularyKey,
    termKey,
    label: termKey,
    sourceTables: new Set(),
  };
  current.sourceTables.add(sourceTable);
  vocabularyTerms.set(key, current);
};

for (const country of countries) addVocabularyTerm("record_status", country.status, "countries");
for (const motorcycle of motorcycles) {
  addVocabularyTerm("record_status", motorcycle.status, "motorcycles");
  addVocabularyTerm("motorcycle_segment", motorcycle.segment, "motorcycles");
}
for (const option of seatOptions) addVocabularyTerm("seat_option_type", option.type, "seat_options");
for (const product of seatCatalog.products) {
  addVocabularyTerm("record_status", product.status, "seat_products");
  addVocabularyTerm("product_type", product.productType, "seat_products");
}
for (const asset of mediaAssets) {
  addVocabularyTerm("record_status", asset.status || "active", "media_assets");
  for (const link of asset.links || []) addVocabularyTerm("media_entity_type", link.entityType, "content_media_links");
}
for (const video of videoResources) {
  addVocabularyTerm("record_status", video.status || "curation_needed", "video_resources");
  for (const link of video.links || []) addVocabularyTerm("video_entity_type", link.entityType, "content_video_links");
}

for (const term of Array.from(vocabularyTerms.values()).sort((a, b) =>
  `${a.vocabularyKey}:${a.termKey}`.localeCompare(`${b.vocabularyKey}:${b.termKey}`)
)) {
  add(`INSERT INTO controlled_vocabulary_terms (
    vocabulary_key, term_key, label, source_data, updated_at
  )
  VALUES (
    ${sqlString(term.vocabularyKey)},
    ${sqlString(term.termKey)},
    ${sqlString(term.label)},
    ${sqlJson({ sourceTables: Array.from(term.sourceTables).sort() })},
    now()
  )
  ON CONFLICT (vocabulary_key, term_key) DO UPDATE SET
    label = EXCLUDED.label,
    source_data = EXCLUDED.source_data,
    updated_at = now();`);
}
counts.controlled_vocabularies = vocabularies.length;
counts.controlled_vocabulary_terms = vocabularyTerms.size;

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
