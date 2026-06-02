# SEO, Analytics, And Minimal Cookie UX Concept

Status: concept draft

Purpose: define a low-friction cookie/consent experience, admin analytics, traffic statistics, and Google-friendly technical SEO requirements.

This is not legal advice. Before public launch, the implemented cookie banner, privacy policy, advertising setup, and analytics setup should be reviewed against the countries where the site is active.

## Cookie UX Principle

The cookie/consent UI must be minimal, calm, and non-blocking.

Recommended placement:

- compact bottom bar,
- bottom left or bottom center on desktop,
- bottom sheet on mobile,
- no large modal unless legally required by the chosen ad/CMP setup,
- do not cover the main beginner help flow,
- do not hide primary buttons,
- do not cause layout shift.

Recommended first text:

```text
We use necessary cookies to keep the site working. Optional cookies help us save your progress, improve the site, and show relevant links. You can change this anytime.
```

Buttons:

- Accept optional
- Necessary only
- Settings

The settings panel can be larger, but the first banner should stay small.

## Cookie Categories

Use clear categories:

- necessary,
- preferences,
- analytics,
- affiliate/paid link measurement,
- advertising.

MVP default:

- necessary: on,
- preferences: optional,
- analytics: optional,
- affiliate click measurement: optional or minimal depending on implementation,
- advertising: off until a proper CMP/ad setup exists.

## Google Ads / AdSense Note

If the site later uses Google AdSense, Ad Manager, or AdMob for users in the EEA, UK, or Switzerland, Google says publishers need a Google-certified Consent Management Platform integrated with the IAB Transparency and Consent Framework when serving ads to those users.

Implication:

- do not add Google advertising before a consent solution is selected,
- keep MVP affiliate links and direct paid links simpler than full ad networks,
- if Google ads are enabled later, use a certified CMP and test mobile UX carefully.

Source:

- Google AdSense EU user consent policy: `https://support.google.com/adsense/answer/7670013`
- Google consent management requirements: `https://support.google.com/adsense/answer/13554116`

## Admin Analytics

The admin should have useful statistics without invasive tracking.

Admin dashboard metrics:

- visitors by day/week/month,
- page views,
- country/language,
- device category,
- traffic source/referrer,
- most viewed bike guides,
- most viewed solution pages,
- questionnaire starts,
- questionnaire completions,
- drop-off step,
- product/affiliate click count,
- feedback submissions,
- search queries inside the site,
- 404 pages,
- slow pages,
- Core Web Vitals status later,
- top external sources clicked,
- conversion from guide to product click.

Privacy-first defaults:

- aggregate reporting,
- IP anonymization/minimization,
- no raw IP in visitor profile,
- no behavioral advertising without consent,
- short retention for raw event data,
- longer retention only for aggregate statistics.

## Admin SEO Dashboard

Admin should be able to monitor:

- indexed pages,
- pages with missing title/meta description,
- missing canonical URL,
- missing hreflang,
- missing structured data,
- duplicate titles,
- broken internal links,
- broken outbound links,
- image alt text issues,
- pages without source references,
- low-content pages,
- pages with stale product prices,
- affiliate links missing `rel="sponsored"`,
- sponsored links missing disclosure,
- pages not mobile-friendly,
- large images,
- slow pages.

## Google-Friendly Technical SEO Requirements

Use official Google Search Central principles:

- make pages useful for users first,
- use clear page titles,
- use descriptive meta descriptions,
- use crawlable links,
- use clean URLs,
- use mobile-friendly responsive design,
- keep mobile and desktop content equivalent,
- use structured data where it matches visible content,
- avoid hiding important content behind scripts that search engines cannot render,
- optimize Core Web Vitals,
- use `rel="sponsored"` for affiliate/sponsored links,
- use `hreflang` for language/country variants,
- use canonical URLs.

Useful structured data types to evaluate later:

- `Article`,
- `FAQPage`,
- `HowTo` if appropriate and still supported for the target rich result,
- `Product`,
- `Review` only when real review data exists,
- `BreadcrumbList`,
- `Organization`,
- `WebSite`,
- `ItemList`.

Sources:

- Google SEO Starter Guide: `https://developers.google.com/search/docs/fundamentals/seo-starter-guide`
- Google structured data gallery: `https://developers.google.com/search/docs/guides/search-gallery`
- Google mobile-first indexing: `https://developers.google.com/search/docs/crawling-indexing/mobile/mobile-sites-mobile-first-indexing`
- Google Core Web Vitals: `https://developers.google.com/search/docs/appearance/core-web-vitals`
- Google outbound link qualification: `https://developers.google.com/search/docs/crawling-indexing/qualify-outbound-links`
- Google affiliate link guidance: `https://developers.google.com/search/blog/2021/07/link-tagging-and-link-spam-update`

## SEO For Country Variants

Each country/language variant should have:

- localized title,
- localized meta description,
- localized intro,
- localized product availability,
- localized currency,
- localized affiliate disclosure,
- localized source links,
- correct `hreflang`,
- canonical URL,
- clear original/translated status.

Avoid:

- auto-translated pages published without review,
- identical pages for every country with only country name changed,
- pretending a product is available locally without verification,
- ranking affiliate links above better local options.

## Minimal MVP Recommendation

For first public version:

1. Small bottom cookie bar.
2. Necessary-only and Accept optional buttons.
3. Settings panel for categories.
4. No third-party ad network.
5. No behavioral ads.
6. Privacy-friendly analytics only after consent decision.
7. Basic admin stats from server logs or first-party events.
8. Google Search Console setup.
9. Sitemap and robots.txt.
10. Structured data for articles, breadcrumbs, products, and organization where valid.
