import { writeFile } from "node:fs/promises";
import countries from "../src/data/i18n/countries.json" with { type: "json" };
import motorcycles from "../src/data/motorcycles/de-list.json" with { type: "json" };

const site = "https://motoseatlab.com";

const staticPaths = [
  "/",
  "/de/",
  "/de/motorrad-sitzbank/",
  "/de/loesungen/",
  "/de/kaufen/",
  "/de/diy/",
  "/de/bilder/",
  "/de/datenschutz/",
  "/de/cookies/",
  "/de/impressum/",
  "/de/admin/assets/",
];

const paths = new Set([
  ...staticPaths,
  ...countries.map((country) => country.defaultPath),
  ...motorcycles.map((motorcycle) => motorcycle.path).filter(Boolean),
]);

const escapeXml = (value) =>
  value
    .replaceAll("&", "&amp;")
    .replaceAll("<", "&lt;")
    .replaceAll(">", "&gt;")
    .replaceAll('"', "&quot;");

const urlEntries = [...paths]
  .sort((left, right) => left.localeCompare(right))
  .map((path) => `  <url>\n    <loc>${escapeXml(new URL(path, site).toString())}</loc>\n  </url>`)
  .join("\n");

const sitemap = `<?xml version="1.0" encoding="UTF-8"?>\n<urlset xmlns="http://www.sitemaps.org/schemas/sitemap/0.9">\n${urlEntries}\n</urlset>\n`;

await writeFile("public/sitemap.xml", sitemap, "utf8");
console.log(`Generated public/sitemap.xml with ${paths.size} URLs.`);
