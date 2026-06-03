# Project Status

Date: 2026-06-03

## Phase

MVP implementation started.

## Done

- Project folder created.
- Project audit and MVP scope drafted.
- MVP specification drafted.
- Concept documented.
- Audience documented.
- Content architecture drafted.
- Design system concept drafted.
- Domain decision drafted: motoseatlab.com.
- Platform architecture drafted.
- Functional architecture drafted.
- Geo intent routing concept drafted.
- SEO/analytics/minimal cookie UX concept drafted.
- Country/localization strategy drafted.
- Country localization market research drafted.
- Bike database strategy drafted.
- First motorcycle guide drafted: Suzuki GSX-S1000GX.
- First country guide drafted: Germany.
- DIY seat requirements drafted.
- Affiliate strategy drafted.
- Research backlog drafted.
- First German page outline drafted.
- SEO/taxonomy drafted.
- Solution decision tree drafted.
- Interactive DIY tools concept drafted.
- Beginner to expert funnel drafted.
- Data model concept drafted.
- Calculation model concept drafted.
- Calculation input skeleton drafted.
- Seat comparison concept drafted.
- Feature roadmap drafted.
- Implementation notes drafted.
- Data maintenance tool concept drafted.
- News/community/source/translation concept drafted.
- Privacy/visitor tracking/ads concept drafted.
- Data entry templates drafted.
- Maintenance workflow drafted.
- Validation and import rules drafted.
- Competitive landscape research drafted.
- Global forum seat pain research drafted.
- Technical parameter model drafted.
- Website stack selected: Astro.
- MVP Astro skeleton created.
- Beginner comfort triage tool added for the first GSX-S1000GX page.
- First qualitative comparison table added for stock seat, reversible add-ons, OEM/aftermarket, and upholsterer/DIY paths.
- Buying guide expanded with product-category checks, affiliate readiness status, and a beginner purchase path.
- DIY page expanded with a minimal documentation and test protocol.
- Project dependencies installed and locked with `package-lock.json`.
- Astro check passes with 0 errors, 0 warnings, and 0 hints.
- Astro static build passes and generates 9 pages in `dist/`.
- Local browser smoke test passed for the GSX-S1000GX page and both recommendation forms.
- Custom seat-layer visual graphic added to make the GSX-S1000GX and DIY pages more readable and distinctive.
- Cookie bar reduced and moved to a less intrusive bottom-right layout.
- Homepage expanded with a reusable diagnostic-map visual and beginner-friendly entry flow.
- AI-generated German touring forest curve hero image added to the project and used on the German homepage.
- Hero image registered in documentation and added to OpenGraph/Twitter sharing metadata.
- GSX-S1000GX guide expanded with rider-profile cards for short rides, weekend rides, and longer touring.
- Local MP4 video added as decorative background for the GSX-S1000GX hero with static poster fallback.
- GSX-S1000GX hero video now has an accessible pause/play toggle with local preference storage.
- Visual design system polished with stronger brand header, richer page background, improved cards, hero status blocks, footer layout, focus states, and mobile refinements.
- First GSX-S1000GX seat option research shortlist added with source links, fitment notes, price notes, confidence levels, and affiliate readiness status.
- GSX-S1000GX page now includes a simple seat option advisor that maps problem, riding use, and budget to the safest first option.
- Navigation simplified with a Motorrad list page, remembered GSX-S1000GX as the current/last model, page jump navigation, and illustrated seat option cards.
- GSX-S1000GX solution and option sections made more scannable with decision strips, compact facts, and expandable detail blocks.
- Local PostgreSQL database layer added with Docker Compose, schema, JSON seed import, Makefile commands, and optional Adminer.
- Database validation views and `make db-check` added for local data quality checks after seeding.
- Database seed expanded with technical motorcycle profiles, seat materials, workshop tools, and German buying channels.
- Website pages now expose the expanded seed data as unified lab cards: DIY materials, workshop tools, German buying channels, and technical motorcycle profile readiness.
- Media asset workflow added with local downloads, source/license metadata, database tables, content links, stable image rendering, and a reusable attribution component.
- GSX-S1000GX guide expanded with visual article sections, practical buying-vs-upholstery guidance, a comfort triage calculator, and an admin asset register with blocked manufacturer-image placeholders.
- Motorcycle selector added to the homepage, motorcycle index, and GSX-S1000GX guide; navigation now clearly points to motorcycle selection.

## Not Started

- Full website implementation.
- Data maintenance tool implementation.
- Numeric calculation function implementation.
- German final copy.
- Real product research.
- Affiliate account setup.
- Affiliate links and final monetized product cards.
- Real country statistics.

## Next Best Step

Improve the first real article draft and add verified source/product placeholders:

```text
Suzuki GSX-S1000GX Sitzbank Komfort:
Schmerzen nach einer Stunde? Ursachen, schnelle Loesungen und DIY-Optionen
```

Recommended working language:

- outline and notes in Slovak,
- final web content in German.

## Open Decisions

- Brand name is Moto Seat Lab.
- First monetization path: Amazon only, or Amazon + motorcycle retailers.
- Whether to publish first as blog/articles or as interactive guide.
