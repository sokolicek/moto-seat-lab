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
const seatOptions = await readJson("src/data/products/gsx-s1000gx-seat-options.json");
const solutionPaths = await readJson("src/data/solution-paths/seat-comfort.json");
const productCategories = await readJson("src/data/product-categories/seat-comfort.json");
const sources = await readJson("src/data/sources/suzuki-gsx-s1000gx.json");
const countryProfile = await readJson("src/data/country-profiles/de.json");
const countryName = countryProfile.name || (countryProfile.country === "DE" ? "Deutschland" : countryProfile.country);

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
    'suzuki-gsx-s1000gx',
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
