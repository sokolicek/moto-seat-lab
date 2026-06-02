# Project Audit And MVP Scope

Status: working audit

Date: 2026-06-02

Purpose: review the current concept documentation, identify duplication and consistency risks, define a simple starting scope, and list missing decisions before implementation starts.

## Executive Summary

Moto Seat Lab now has strong concept coverage:

- beginner-first funnel,
- seat comfort theory,
- data model,
- calculation model,
- product/affiliate model,
- localization,
- configurable design,
- privacy/cookies,
- analytics/SEO,
- news/community,
- future platform expansion beyond seats.

The main risk is not missing ideas. The main risk is starting too big.

The project needs a deliberately small first implementation:

```text
One country, one language, one motorcycle, one beginner problem, one honest recommendation flow.
```

Recommended first public version:

```text
Germany / German / Suzuki GSX-S1000GX / original seat hurts after about one hour.
```

## Consistency Review

### What Is Consistent

- The project is still concept-stage, no website code yet.
- The first pilot is consistently Germany + German + Suzuki GSX-S1000GX.
- The tone is consistently practical, honest, and not sales-heavy.
- The beginner-first principle is now clear: help first, expert details later.
- Affiliate links must be disclosed and must not control recommendation ranking.
- Forum/community data is consistently treated as anecdotal until reviewed.
- News/RSS/forum features are consistently marked as later, not MVP.
- Admin Studio is consistently later; structured files should come first.
- PostgreSQL is a future option, not required before data stabilizes.
- Privacy/cookie direction is consistent: first-party, minimal, consent-aware.

### Where The Docs Are Too Broad

The following topics are valid but too broad for first implementation:

- multi-country localization,
- Southeast Asia scooter/underbone commuter flows,
- country-specific design variants,
- automatic IP-based geo intent routing,
- full admin studio,
- full database,
- forum,
- RSS/news ingestion,
- ad network integration,
- expert/lab calculations,
- future tire advisor,
- user accounts,
- AI translation workflow,
- paid placements.

They should stay documented but explicitly outside the first MVP.

Forum research confirms that Southeast Asian markets can be covered later, but they need different defaults: scooter/underbone first, low-cost fixes first, heat/rain comfort first, and premium imported seats only as advanced options.

Geo intent routing should eventually use IP-derived country as a weak signal to choose these defaults, but first MVP should use Germany explicitly and show a manual country selector.

## Duplicate Or Overlapping Documents

### Roadmaps

Overlap:

- `docs/roadmap.md`
- `docs/feature-roadmap.md`
- `docs/STATUS.md`
- MVP notes inside `docs/implementation-notes.md`
- MVP notes inside `docs/platform-architecture.md`
- MVP notes inside `docs/design-system-concept.md`
- MVP notes inside `docs/privacy-visitor-tracking-ads-concept.md`
- MVP notes inside `docs/seo-analytics-cookie-ux-concept.md`

Recommendation:

- keep `docs/roadmap.md` as the simple human roadmap,
- keep `docs/feature-roadmap.md` as the long feature roadmap,
- use this file as the current MVP source of truth,
- update `docs/STATUS.md` to point to this file as the next decision reference.

### Privacy / Cookies / Ads

Overlap:

- `docs/privacy-visitor-tracking-ads-concept.md`
- `docs/seo-analytics-cookie-ux-concept.md`
- affiliate rules in `docs/monetization/affiliate-strategy.md`
- affiliate rules in `docs/seat-comparison.md`
- affiliate rules in `docs/platform-architecture.md`

Recommendation:

- privacy principles live in `privacy-visitor-tracking-ads-concept.md`,
- cookie UI and Google/SEO details live in `seo-analytics-cookie-ux-concept.md`,
- affiliate editorial rules live in `affiliate-strategy.md`,
- implementation should import/link these policies rather than repeat them everywhere.

### Localization

Overlap:

- `docs/countries-and-localization.md`
- `docs/research/country-localization-market-research.md`
- localization notes in `docs/design-system-concept.md`
- localization entities in `docs/data-model.md`
- translation workflow in `docs/news-community-translation-concept.md`

Recommendation:

- `countries-and-localization.md` remains the high-level localization strategy,
- `country-localization-market-research.md` remains research,
- `design-system-concept.md` defines design variants,
- `data-model.md` only stores entities and links out.

### Data And Calculation

Overlap:

- `docs/data-model.md`
- `docs/technical-parameter-model.md`
- `docs/calculation-input-skeleton.md`
- `docs/calculation-model.md`
- `docs/interactive-tools.md`
- `docs/seat-comparison.md`

Recommendation:

- `calculation-input-skeleton.md` should be the source for what the user is asked,
- `technical-parameter-model.md` should be the source for expert/measured fields,
- `calculation-model.md` should be the source for outputs and formulas,
- `data-model.md` should remain entity-level only.

## Initial Simplicity Recommendation

### First Public MVP

Build only:

- German landing/help page,
- Suzuki GSX-S1000GX guide,
- beginner problem flow,
- static comparison of solution paths,
- Germany buying/source notes,
- basic affiliate disclosure,
- minimal cookie bar,
- privacy/cookie/affiliate policy pages,
- static JSON/YAML data for one motorcycle and a few product categories.

Do not build yet:

- database,
- admin UI,
- user accounts,
- forum,
- RSS/news ingestion,
- AI translation publishing,
- ad networks,
- advanced lab calculations,
- multi-country auto-design,
- full product price tracking.

### First User Flow

```text
My original GSX-S1000GX seat hurts after about one hour.
```

Ask only:

1. Do you mostly ride short, country, highway/touring, city, or passenger/luggage?
2. What bothers you most: hard, soft, sliding, heat, numbness, tailbone, knees/hips?
3. Do you want to buy, use an upholsterer, try a reversible add-on, DIY, or are you not sure?
4. What is your budget level: low, medium, high?

Then show:

- likely problem category,
- recommended first step,
- buy-ready options to research,
- reversible cheap tests,
- professional upholsterer path,
- DIY path only as optional,
- warnings,
- missing data,
- confidence level.

### First Data Scope

Use structured files first.

Minimum records:

- one motorcycle: Suzuki GSX-S1000GX,
- stock seat baseline,
- Suzuki OEM accessory seats if confirmed,
- solution paths,
- product categories,
- Germany country profile,
- source references,
- affiliate disclosure text.

Optional first product categories:

- 3D mesh cover,
- air cushion,
- gel pad warning category,
- professional upholstery,
- OEM comfort/premium/low seat,
- aftermarket seat placeholder.

### First Design Scope

Use one configurable design variant:

```text
technical_touring
```

Support:

- mobile,
- tablet,
- desktop,
- light theme,
- no-image fallback,
- bottom minimal cookie bar.

Do not build a theme editor yet.

### First SEO Scope

Required:

- clean URLs,
- responsive mobile-first layout,
- title and meta description,
- canonical URL,
- sitemap,
- robots.txt,
- Google Search Console readiness,
- Article/Breadcrumb structured data where valid,
- `rel="sponsored"` for affiliate/sponsored links,
- German page copy written for real users.

Later:

- hreflang,
- multi-country variants,
- automated SEO dashboard,
- product structured data after real product data exists.

## Missing Decisions

Before implementation, define:

1. Website stack: Astro is currently the strongest fit for content-first static MVP.
2. Content language workflow: Slovak notes -> German final copy -> English docs.
3. Data format for MVP: JSON or YAML.
4. First exact page list.
5. First exact URL structure.
6. Whether affiliate links are enabled in MVP or only placeholders.
7. Whether analytics is enabled in MVP or only server/log-based later.
8. Cookie banner text and categories for first country.
9. Privacy policy and affiliate disclosure draft.
10. Visual direction for first German page.
11. First source list for GSX-S1000GX.
12. First product/source verification standard.
13. Who is allowed to publish data: only admin for MVP.
14. How to mark unverified products.
15. Whether user feedback form is MVP or post-MVP.

## Things Still Missing From The Concept

### Legal / Compliance

- Impressum requirement for Germany,
- Datenschutzerklärung,
- cookie policy,
- affiliate disclosure per market,
- contact page,
- copyright policy for external sources,
- user feedback terms if feedback is enabled.

### Editorial

- source citation style,
- review/update cadence for pages,
- tone guide for German copy,
- rule for when a claim is too strong,
- rule for product recommendation language.

### Operations

- backup strategy,
- content publishing checklist,
- broken link review cadence,
- stale product review cadence,
- GitHub issue labels or project board,
- release checklist.

### Technical

- stack decision,
- hosting target,
- local dev command,
- build command,
- data validation command,
- test strategy,
- accessibility checklist,
- performance budget,
- image handling strategy.

### Data

- exact schema for first JSON/YAML files,
- source confidence enum finalization,
- first `country_market_profile` record for Germany,
- first `solution_path` records,
- first `product_category` records,
- first `source_reference` records.

## Proposed Next Three Steps

1. Freeze MVP scope using this document.
2. Decide stack and data format.
3. Create first implementation skeleton:

```text
Astro static site
German GSX-S1000GX page
structured data files
minimal cookie bar placeholder
basic SEO files
no database
no admin
no forum
no ads
```

## Recommended Source Of Truth Map

- Project status: `docs/STATUS.md`
- MVP scope: `docs/project-audit-and-mvp-scope.md`
- Long roadmap: `docs/feature-roadmap.md`
- Simple roadmap: `docs/roadmap.md`
- Platform architecture: `docs/platform-architecture.md`
- Data entities: `docs/data-model.md`
- Beginner inputs: `docs/calculation-input-skeleton.md`
- Expert parameters: `docs/technical-parameter-model.md`
- Design system: `docs/design-system-concept.md`
- Privacy: `docs/privacy-visitor-tracking-ads-concept.md`
- Cookie/SEO/analytics: `docs/seo-analytics-cookie-ux-concept.md`
