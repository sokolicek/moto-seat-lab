# MVP Specification

Status: proposed

Date: 2026-06-02

Purpose: freeze the first implementation scope for Moto Seat Lab motorcycle seats.

## MVP Summary

The first version is a small German content-first website for one motorcycle and one concrete problem:

```text
Suzuki GSX-S1000GX original seat hurts after about one hour.
```

The MVP must help the rider quickly understand realistic solution paths without forcing expert measurements.

## Target User

Primary user:

- German-speaking Suzuki GSX-S1000GX owner,
- unhappy with the original seat,
- pain or discomfort after about one hour,
- not sure whether to buy, modify, use an upholsterer, or try a cheap add-on.

Secondary user:

- rider researching motorcycle seat comfort before buying products,
- DIY-curious rider who wants to avoid ruining the original seat.

## Recommended Stack

Use:

- Astro,
- Markdown or MDX content,
- JSON data files,
- static build,
- minimal client-side JavaScript for questionnaire/result UI,
- no database.

Reason:

- content-first,
- SEO-friendly,
- simple hosting,
- easy to evolve,
- data files can later migrate to PostgreSQL/admin studio.

## MVP Pages

### Public Pages

Required:

```text
/
/de/
/de/motorrad-sitzbank/suzuki-gsx-s1000gx/
/de/loesungen/
/de/kaufen/
/de/diy/
/de/datenschutz/
/de/cookies/
/de/impressum/
```

Optional if time is available:

```text
/de/materialien/
/de/quellen/
```

### Page Purpose

`/`

- redirect or link to the German pilot page,
- simple language/country entry.

`/de/`

- German start page,
- beginner-first entry,
- direct path to GSX-S1000GX guide.

`/de/motorrad-sitzbank/suzuki-gsx-s1000gx/`

- main MVP page,
- article + beginner flow + static recommendations.

`/de/loesungen/`

- explain solution paths:
  - reversible add-on,
  - OEM comfort seat,
  - aftermarket seat,
  - professional upholsterer,
  - DIY.

`/de/kaufen/`

- buying guide for Germany,
- product categories and source confidence,
- no fake product certainty.

`/de/diy/`

- safe beginner DIY checklist,
- spare-seat warning,
- foam/gel/mesh basics.

Legal/minimum pages:

- privacy,
- cookies,
- impressum,
- affiliate disclosure section where needed.

## First User Flow

Prompt:

```text
Deine originale GSX-S1000GX Sitzbank tut nach etwa einer Stunde weh?
```

Ask four beginner questions:

1. Main ride type:
   - short rides,
   - country roads,
   - highway/touring,
   - city,
   - passenger/luggage.
2. Main problem:
   - too hard,
   - too soft,
   - sliding forward,
   - heat/sweat,
   - numbness,
   - tailbone,
   - knees/hips.
3. Preferred path:
   - buy,
   - upholsterer,
   - reversible add-on,
   - DIY,
   - not sure.
4. Budget:
   - low,
   - medium,
   - high.

Output:

- likely problem category,
- first recommended step,
- solution path cards,
- warnings,
- source confidence,
- missing data,
- next action.

## Solution Path Defaults For Germany

Default order:

1. Diagnose problem.
2. Try low-risk reversible option if uncertainty or low budget.
3. Check OEM Suzuki accessory seat options if confirmed.
4. Compare aftermarket seats if verified.
5. Consider professional upholsterer for long-distance comfort.
6. DIY only if user explicitly wants it.

## MVP Data Files

Use JSON for first MVP.

Recommended folder:

```text
src/data/
  motorcycles/suzuki-gsx-s1000gx.json
  country-profiles/de.json
  solution-paths/seat-comfort.json
  product-categories/seat-comfort.json
  sources/suzuki-gsx-s1000gx.json
  disclosures/de.json
```

### Required Data Records

Motorcycle:

- brand,
- model,
- year range,
- category,
- country relevance,
- stock seat baseline placeholder,
- known research status,
- source references.

Country profile:

- country,
- language,
- currency,
- design variant,
- solution order,
- affiliate disclosure text,
- cookie mode notes.

Solution paths:

- reversible add-on,
- OEM comfort/premium/low seat,
- aftermarket seat,
- professional upholsterer,
- DIY.

Product categories:

- 3D mesh cover,
- air cushion,
- gel pad,
- foam sheets,
- cover material,
- contact adhesive,
- upholstery stapler,
- heated seat kit,
- professional upholstery service.

Sources:

- official Suzuki page,
- Suzuki accessory page if verified,
- aftermarket pages if verified,
- forum research notes marked anecdotal.

## MVP Components

Required:

- layout,
- header,
- footer,
- language/country switch placeholder,
- problem questionnaire,
- solution path card,
- warning panel,
- confidence badge,
- source list,
- affiliate disclosure block,
- minimal cookie bar,
- mobile comparison card.

Optional:

- product card,
- simple chart,
- source confidence filter.

## Design Scope

Use one default design variant:

```text
technical_touring
```

Requirements:

- mobile first,
- tablet usable,
- desktop usable,
- light theme,
- clear reading layout,
- no-image fallback,
- bottom minimal cookie bar,
- no theme editor yet.

## SEO Scope

Required:

- descriptive titles,
- meta descriptions,
- canonical URLs,
- sitemap,
- robots.txt,
- responsive layout,
- Open Graph basics,
- `Article` structured data where appropriate,
- `BreadcrumbList` structured data,
- `rel="sponsored"` on affiliate/sponsored links,
- no auto-generated thin country pages.

Post-MVP:

- hreflang,
- product structured data,
- automated SEO dashboard,
- multi-country pages.

## Privacy / Cookie Scope

MVP:

- minimal bottom cookie bar,
- necessary only by default,
- optional preferences/analytics categories shown in settings,
- no third-party advertising,
- no behavioral ads,
- no IP-based automatic routing yet,
- country selector manual.

Allowed:

- first-party cookie/local storage for cookie preference,
- first-party preference for country/language if user selects it.

Post-MVP:

- anonymous progress saving,
- IP-derived country guess,
- analytics,
- affiliate click analytics.

## Explicitly Out Of Scope For MVP

- database,
- PostgreSQL,
- admin studio,
- forum,
- RSS/news ingestion,
- user accounts,
- automatic IP geo routing,
- multi-country localization,
- AI translation publishing,
- ad network integration,
- sponsored placements,
- advanced expert calculations,
- tire/bicycle seat modules,
- full product price tracking.

## Content Requirements

German copy must be:

- direct,
- practical,
- honest,
- not sales-heavy,
- clear about uncertainty,
- clear that forum data is anecdotal,
- clear that affiliate links may exist.

Avoid:

- "this will solve your problem",
- "best seat for everyone",
- over-promising gel/air/foam,
- ranking by affiliate value.

## Done Criteria

The MVP is done when:

- required pages exist,
- GSX-S1000GX main page is readable in German,
- beginner flow works on mobile and desktop,
- solution cards show realistic warnings,
- data files validate,
- sitemap and robots.txt exist,
- cookie bar does not block content,
- privacy/cookie/impressum placeholders exist,
- affiliate disclosure exists,
- no raw secrets are committed,
- build passes,
- basic accessibility check passes,
- mobile layout has no overlapping text.

## Next Implementation Steps

1. Create Astro project skeleton.
2. Add JSON data folder.
3. Add German page routes.
4. Add layout and basic design tokens.
5. Add questionnaire component.
6. Add solution cards from data.
7. Add cookie bar placeholder.
8. Add SEO files.
9. Run build and local preview.
