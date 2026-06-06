# Country Localization Strategy

## Goal

Moto Seat Lab should feel local by default. A rider from Germany should see BMW GS, touring seats and DACH suppliers early. A rider from Thailand or Indonesia should see scooter, commuter, heat, rain and low-cost pad advice before premium imported seats.

## Current Implementation

The first country-intelligence layer is now stored in:

- `src/data/country-seat-intelligence.json`
- PostgreSQL table `country_seat_strategies`
- PostgreSQL table `country_research_sources`
- admin page `/de/admin/intelligence/`

It covers:

- market mode per country,
- lead motorcycle segments,
- lead motorcycle slugs,
- likely pain points,
- first recommendation,
- budget logic,
- local forum/research sources,
- buying priorities,
- admin notes.

## Research Signals Used

Current research supports these starting assumptions:

- DACH and USA: large touring/adventure bikes, BMW GS, Harley touring, premium seats, OEM versus aftermarket comparisons.
- France and Italy: comfort saddle, gel, upholstery/sellier/tappezziere and style-versus-function tradeoffs.
- Poland and Turkey: budget, gel, local upholstery and practical modification questions.
- Thailand, Indonesia, Malaysia and China: scooter/commuter first, heat/rain, low-cost pads, breathable covers and local seat shops.

These are not final rankings. They are admin-editable starting hypotheses.

## Full Catalog Localization Plan

Do not translate the full catalog blindly. Use this order:

1. Translate country home and navigation.
2. Localize country-intelligence strategy and source links.
3. Localize motorcycle priority order per country.
4. Translate product categories and solution paths.
5. Translate materials, tools and supplies.
6. Translate motorcycle detail pages.
7. Add country-specific buying channels and affiliate disclosure.
8. Review claims before publishing.

## Admin And Analytics

The static MVP can show catalog stats, but it cannot record visits by itself.

Recommended production options:

- Google Search Console for search visibility and indexing.
- Plausible or Umami for privacy-friendly visitor statistics.
- GA4 only if consent mode and cookie disclosure are handled clearly.

The database has `visitor_events` prepared for a future backend or hosted analytics import, but it is intentionally empty in the static MVP.
