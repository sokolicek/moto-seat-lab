# Geo Intent Routing Concept

Status: concept draft

Purpose: define how Moto Seat Lab should adapt the first page, product suggestions, design defaults, and recommendation order based on the visitor's likely country or region.

## Core Idea

The website should not show the same first answer to every visitor.

If a visitor likely comes from Germany, Austria, or Switzerland, the first useful answer may include:

- OEM comfort seat,
- premium aftermarket seat,
- Sargent/Corbin/Bagster/Touratech/Wunderlich-style options,
- local upholsterer,
- long-distance touring comparison,
- seat height and knee angle warnings.

If a visitor likely comes from Indonesia, Thailand, Malaysia, or similar scooter/commuter-heavy markets, the first useful answer should usually include:

- low-cost seat cushion,
- 3D mesh/breathable cover,
- rain/waterproof cover,
- foam refresh,
- local upholstery repair,
- scooter/underbone commuter comfort,
- heat/rain/bad-road warnings.

This is not only translation. It is intent routing.

## Privacy-Safe Geo Detection

Use IP only for approximate region/country detection.

Do:

- infer country/region from request IP,
- store derived country if needed,
- let user change country manually,
- avoid storing raw IP in long-term visitor profile,
- explain that recommendations are localized,
- fall back to global beginner flow when uncertain.

Do not:

- identify a returning visitor primarily by IP,
- build long-term behavior profiles by raw IP,
- hide country/language controls,
- assume the IP country is always correct,
- make expensive recommendations only because a country is considered wealthy.

## Routing Inputs

Initial routing can use:

- IP-derived country,
- browser language,
- selected language,
- selected country,
- URL country path,
- previous first-party visitor preference,
- explicit motorcycle model,
- explicit ride use case.

Priority order:

1. Explicit user country selection.
2. Country in URL.
3. Saved first-party preference.
4. IP-derived country.
5. Browser language.
6. Global default.

## Country Market Profile

Each country should have a market profile that controls defaults.

Fields:

- country,
- market_group,
- default_language,
- default_currency,
- default_design_variant,
- default_motorcycle_categories,
- default_solution_order,
- default_price_band,
- climate_profile,
- common_use_cases,
- premium_aftermarket_visibility,
- local_repair_visibility,
- local_marketplace_visibility,
- source_priority,
- affiliate_marketplaces,
- manual_override_allowed.

Example: Germany

```yaml
country: DE
market_group: premium_touring
default_language: de
default_design_variant: technical_touring
default_motorcycle_categories:
  - sport_touring
  - adventure_touring
  - touring
default_solution_order:
  - diagnose_problem
  - oem_comfort_seat
  - aftermarket_seat
  - professional_upholsterer
  - reversible_addon
  - diy
premium_aftermarket_visibility: high
local_repair_visibility: medium
```

Example: Indonesia

```yaml
country: ID
market_group: scooter_commuter
default_language: id
default_design_variant: scooter_commuter_mobile
default_motorcycle_categories:
  - scooter
  - underbone
  - commuter
default_solution_order:
  - diagnose_problem
  - cheap_reversible_addon
  - breathable_mesh_cover
  - rain_cover
  - local_foam_repair
  - local_upholsterer
  - aftermarket_seat
premium_aftermarket_visibility: low
local_repair_visibility: high
local_marketplace_visibility: high
```

## Recommendation Examples

### Visitor From Germany

First screen:

```text
Original seat hurts after about one hour?
Compare OEM comfort seats, aftermarket seats, local upholsterers, and simple reversible tests for your motorcycle.
```

Default recommendation order:

1. Identify pain type.
2. Check OEM comfort/low/high/heated seat.
3. Check verified aftermarket options.
4. Consider local upholsterer.
5. Try reversible add-on if budget is low or uncertainty is high.
6. DIY only if user wants it.

### Visitor From Indonesia

First screen:

```text
Seat uncomfortable on daily rides?
Start with low-cost fixes: breathable mesh, cover, foam refresh, and local seat repair before expensive imported parts.
```

Default recommendation order:

1. Identify pain type.
2. Check if seat is too thin, worn, hot, slippery, or wet.
3. Recommend mesh/cover/cushion when appropriate.
4. Recommend local foam repair or re-covering.
5. Warn against shaving foam too thin.
6. Premium imported seat only if user asks or has high budget.

## User Override

Every localized recommendation should show:

```text
Showing recommendations for Germany. Change country.
```

or:

```text
Showing scooter/commuter-first recommendations for Indonesia. Change country or motorcycle type.
```

Why:

- IP geolocation can be wrong,
- VPNs exist,
- travelers exist,
- expats may want another market,
- product availability differs by country.

## Data Model Additions

Future entities:

- `geo_resolution`
- `country_market_profile`
- `market_group`
- `localized_recommendation_default`
- `solution_order_rule`

## Geo Resolution

Fields:

- id,
- visitor_session_id,
- ip_country_guess,
- browser_language,
- url_country,
- saved_country,
- selected_country,
- final_country,
- confidence_level,
- created_at.

## Solution Order Rule

Fields:

- id,
- country_market_profile_id,
- domain,
- motorcycle_category,
- use_case,
- budget_level,
- solution_path_key,
- rank,
- visibility,
- reason,
- enabled.

## Admin Controls

Administrator should be able to configure:

- market groups,
- country-to-market-group mapping,
- default solution order per country,
- premium product visibility,
- low-cost product visibility,
- marketplace links per country,
- default design variant per country,
- fallback country,
- whether IP geo detection is enabled,
- whether to ask country before routing,
- IP geolocation provider,
- IP retention policy.

## MVP Recommendation

For the first German MVP:

- implement the data structure conceptually,
- use Germany as explicit default,
- show country selector,
- do not implement automatic IP routing yet unless simple and privacy-safe,
- prepare country profile files for Germany and placeholder Southeast Asia examples.

For later:

- add IP-derived country guess,
- route to country market profile,
- add Indonesia/Thailand/Malaysia scooter-first pages,
- test whether localized routing improves engagement.
