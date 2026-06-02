# Functional Architecture

Status: concept draft

Purpose: describe the main application functions and which parts should be shared across future domains such as seats, tires, tools, and other motorcycle advisory modules.

## Function Groups

### 1. Beginner Guidance

Purpose:

- help a non-expert user immediately.

Shared functions:

- detect user intent,
- ask minimum questions,
- map problem to domain,
- produce first solution paths,
- show confidence and missing data.

Seat-specific:

- original seat hurts,
- sliding,
- pressure,
- heat,
- reach/height,
- DIY or buy.

Future tire-specific:

- tire worn out,
- bad wet grip,
- vibration/noise,
- touring vs sport vs commuting,
- which tire size and rating is needed.

### 2. Product Comparison

Purpose:

- compare product options honestly.

Shared functions:

- filter by country,
- filter by motorcycle fitment,
- filter by budget,
- compare cost,
- compare pros/cons,
- attach offers and affiliate links,
- show return/warranty notes,
- show source confidence.

Seat-specific:

- OEM comfort seat vs aftermarket vs upholsterer vs add-on vs DIY.

Future tire-specific:

- touring tire vs sport tire vs adventure tire,
- wet/cold/mileage tradeoffs,
- front/rear pair compatibility,
- load/speed rating check.

### 3. Recommendation Engine

Purpose:

- turn user inputs and data into ranked solution paths.

Shared pipeline:

```text
normalize user input
resolve locale
resolve motorcycle
resolve domain
load domain data
load compatible products/offers
score solution paths
apply warnings
rank options
attach source confidence
localize result
```

Shared functions:

- unit conversion,
- country/currency handling,
- missing data detection,
- confidence scoring,
- product fitment filtering,
- affiliate disclosure,
- recommendation explanation formatting.

Seat-specific functions:

- reach-to-ground risk,
- pressure risk,
- rider triangle risk,
- heat risk,
- DIY difficulty,
- seat load estimate.

Future tire-specific functions:

- tire size validation,
- load/speed rating validation,
- wet grip suitability,
- mileage expectation,
- use-case match,
- forum/test confidence aggregation.

### 4. Content And News

Purpose:

- keep articles, news links, source directories, and translated summaries organized.

Shared functions:

- manage content pages,
- manage content sources,
- curate news links,
- tag topics,
- generate country pages,
- create short summaries,
- manage translations,
- detect stale sources.

Important:

- external sources are linked and summarized,
- full external articles are not copied,
- forum claims are anecdotal until reviewed.

### 5. Community And Feedback

Purpose:

- collect real rider experience without corrupting verified data.

Shared functions:

- feedback submission,
- link submission,
- correction submission,
- moderation,
- spam detection,
- experience report publishing,
- trust marking.

Rules:

- feedback starts as unverified,
- admin can promote it to a research note,
- multiple consistent reports can raise confidence,
- no user report directly overrides verified data.

### 6. Admin Studio

Purpose:

- let the site owner maintain data, sources, products, translations, feedback, and publication status.

Shared functions:

- CRUD for motorcycles,
- CRUD for products,
- CRUD for offers,
- source management,
- news queue,
- feedback queue,
- translation queue,
- moderation queue,
- validation issues,
- publish/unpublish.

Domain-specific editors:

- seat dimensions,
- seat layers,
- material stacks,
- DIY plans,
- tire sizes,
- tire fitment,
- tire test references.

### 7. Localization And Translation

Purpose:

- show the right language, country, currency, units, shops, and legal notices.

Shared functions:

- locale detection,
- language switch,
- country switch,
- unit conversion,
- currency display,
- translated content lookup,
- translation job creation,
- admin approval.

Do not auto-publish machine translations for safety or buying recommendations without admin review.

### 8. Affiliate And Monetization

Purpose:

- monetize without breaking trust.

Shared functions:

- retailer management,
- affiliate program management,
- affiliate link generation/storage,
- offer localization,
- disclosure rendering,
- stale link checks.

Rules:

- recommendations are ranked by fit,
- affiliate links are disclosed,
- non-affiliate alternatives remain allowed,
- admin can disable affiliate links per country/source/page.

## Recommended Function Boundaries

Keep these as separate code modules later:

```text
/core
/domains/seat-comfort
/domains/tires
/content
/products
/recommendations
/community
/localization
/admin
/integrations
```

First implementation can still be one app. The folder/module boundaries should already reflect the future architecture.

## Function Done Criteria

A function is ready only when:

- it works with missing data,
- it shows confidence,
- it has admin-controlled sources,
- it supports localization,
- it does not hard-code affiliate priority,
- it can be tested with one motorcycle and one domain,
- it can be extended to another domain without rewriting the whole flow.
