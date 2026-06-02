# Privacy, Visitor Continuity, Cookies, Ads, And Paid Links Concept

Status: concept draft

Purpose: define how Moto Seat Lab can remember returning visitors, let them continue where they stopped, support cookies, advertising, paid links, affiliate links, and analytics while keeping the architecture privacy-first and configurable by the administrator.

This is not legal advice. Before public launch in the EU, privacy/cookie text should be reviewed against the actual implementation and target countries.

## Core Principle

Do not identify returning visitors by IP as the main mechanism.

Use:

- anonymous session ID,
- first-party cookies or local storage where appropriate,
- optional account/login later,
- explicit consent for analytics, advertising, and tracking cookies,
- IP address only where needed for security, abuse prevention, approximate country detection, or server logs with retention limits.

Why:

- IP addresses and cookie IDs can be personal data under GDPR.
- IP addresses change and are shared by many people.
- Tracking by IP alone is unreliable and privacy-risky.
- Continuing progress can work better with a pseudonymous visitor/session token.

References checked:

- European Commission GDPR overview: `https://commission.europa.eu/law/law-topic/data-protection/reform/what-does-general-data-protection-regulation-gdpr-govern_en`
- European Commission cookies policy example: `https://commission.europa.eu/cookies-policy_en`
- European Commission consent guidance: `https://commission.europa.eu/law/law-topic/data-protection/rules-business-and-organisations/legal-grounds-processing-data/grounds-processing/when-consent-valid_en`

## Visitor Continuity Goals

The site should let a returning visitor continue:

- questionnaire progress,
- selected motorcycle,
- selected country/language,
- selected theme/layout,
- selected content depth,
- saved comparison,
- last recommendation result,
- DIY plan draft,
- product shortlist,
- feedback draft.

This should be possible without forcing an account.

## Visitor Recognition Levels

### Level 0: No Tracking

Use when:

- visitor rejects optional cookies,
- private browsing,
- no consent.

Allowed:

- essential session cookie if needed for requested functionality,
- language/country preference if strictly necessary or consented depending on implementation,
- server security logs with retention policy.

Experience:

- can browse content,
- can use calculator in current session,
- progress may not persist after closing browser.

### Level 1: Anonymous Local Continuity

Use:

- first-party visitor/session ID,
- local storage or first-party cookie,
- no third-party tracking.

Stores:

- anonymous visitor ID,
- consent state,
- locale preferences,
- unfinished questionnaire state,
- comparison state,
- last viewed bike guide,
- saved public recommendations.

Experience:

- visitor can continue where they stopped on the same browser/device.

### Level 2: Optional Account

Use later if needed.

Stores:

- email/login,
- saved profiles,
- saved bikes,
- saved recommendations,
- feedback history,
- notification preferences.

Experience:

- visitor can continue across devices.

### Level 3: Marketing/Advertising Tracking

Only with explicit consent where required.

May include:

- ad personalization,
- retargeting,
- third-party scripts,
- paid campaign attribution,
- affiliate click tracking.

Must include:

- consent controls,
- opt-out,
- disclosure,
- vendor list,
- retention policy.

## Cookie Categories

### Strictly Necessary

Purpose:

- site operation,
- security,
- consent storage,
- session state for requested tools.

Examples:

- consent preference cookie,
- anonymous session cookie,
- CSRF protection,
- admin login session.

Consent:

- usually no optional consent banner approval needed for strictly necessary functionality, but still disclose in cookie policy.

### Preferences

Purpose:

- language,
- country,
- currency,
- units,
- theme,
- layout,
- image mode,
- content depth.

Consent:

- should be configurable depending on jurisdiction and implementation.

### Analytics

Purpose:

- understand usage,
- popular pages,
- conversion paths,
- calculator completion,
- broken flows.

Preferred:

- privacy-friendly first-party analytics,
- aggregated statistics,
- IP anonymization or no IP storage where possible.

Consent:

- use consent-first unless a specific local legal basis is reviewed and documented.

### Advertising And Paid Links

Purpose:

- ad personalization,
- paid campaign tracking,
- sponsored placement measurement,
- third-party ad networks.

Consent:

- explicit opt-in before loading third-party advertising/tracking scripts where required.

### Affiliate

Purpose:

- record affiliate click,
- disclose monetized links,
- route user to retailer.

Architecture:

- affiliate link stored separately from canonical URL,
- click event recorded with minimal data,
- no affiliate ranking bias,
- disclosure near link.

Consent:

- simple outbound affiliate links may not need the same treatment as behavioral ads, but tracking cookies, retargeting, and third-party scripts should be consent-managed.

## IP Address Handling

Recommended use:

- security logs,
- rate limiting,
- spam protection,
- approximate country detection,
- country market profile selection,
- localized recommendation defaults,
- fraud prevention,
- admin audit logs.

Avoid:

- using IP as the main visitor identity,
- long-term behavioral profiles by IP,
- hiding the country override from the user,
- showing admin raw IPs unless needed,
- exporting raw IPs unnecessarily.

Possible privacy measures:

- hash IP with rotating salt,
- truncate IP,
- short retention window,
- store country derived from IP instead of raw IP where possible,
- separate security logs from recommendation data.

## Geo-Based Recommendation Routing

IP-derived country may be used to choose the initial country market profile.

Example:

- Germany: OEM comfort seat, aftermarket seat, upholsterer, touring comparison.
- Indonesia/Thailand/Malaysia: low-cost cushion, mesh cover, rain cover, foam repair, local upholsterer.

Rules:

- IP country is only a guess,
- explicit user country selection wins,
- URL country wins over IP,
- saved first-party country preference wins over IP,
- show "change country" near localized recommendations,
- do not store raw IP in recommendation records.

## Data Model Additions

Future entities:

- `visitor`
- `visitor_session`
- `consent_record`
- `cookie_preference`
- `visitor_state`
- `saved_recommendation`
- `saved_comparison`
- `analytics_event`
- `affiliate_click`
- `ad_impression`
- `sponsored_link`
- `privacy_request`
- `data_retention_policy`

## Visitor

Fields:

- id,
- anonymous_id,
- account_id nullable,
- first_seen_at,
- last_seen_at,
- country_guess,
- preferred_language,
- preferred_country,
- consent_status_summary,
- created_at,
- updated_at.

Do not store raw IP here.

## Visitor Session

Fields:

- id,
- visitor_id,
- session_token_hash,
- started_at,
- last_seen_at,
- user_agent_hash,
- ip_hash_or_truncated,
- country_guess,
- referrer_domain,
- landing_page,
- consent_snapshot_id,
- security_flags.

## Consent Record

Fields:

- id,
- visitor_id nullable,
- session_id nullable,
- consent_version,
- necessary_enabled,
- preferences_enabled,
- analytics_enabled,
- advertising_enabled,
- affiliate_tracking_enabled,
- consent_source,
- country,
- language,
- created_at,
- withdrawn_at.

## Visitor State

Fields:

- id,
- visitor_id,
- state_type,
- domain,
- state_json,
- expires_at,
- created_at,
- updated_at.

Examples:

- seat questionnaire progress,
- chosen motorcycle,
- selected country,
- selected language,
- comparison shortlist,
- DIY plan draft.

## Analytics Event

Fields:

- id,
- visitor_id nullable,
- session_id nullable,
- event_type,
- domain,
- page_path,
- entity_type,
- entity_id,
- referrer_domain,
- consent_snapshot_id,
- event_data_json,
- created_at.

Store only when allowed by consent/config.

## Affiliate Click

Fields:

- id,
- visitor_id nullable,
- session_id nullable,
- product_offer_id,
- retailer_id,
- affiliate_program_id,
- source_page,
- canonical_url,
- affiliate_url,
- disclosure_shown,
- consent_snapshot_id,
- created_at.

## Sponsored Link / Ad Placement

Fields:

- id,
- placement_key,
- sponsor_name,
- target_url,
- country,
- language,
- domain,
- starts_at,
- ends_at,
- paid_relationship_type,
- disclosure_text,
- enabled,
- notes.

Paid relationship types:

- affiliate,
- sponsored_link,
- display_ad,
- paid_review,
- partner_offer.

Paid reviews should be avoided or very clearly separated from independent recommendations.

## Admin Controls

Administrator should be able to configure:

- cookie categories enabled,
- default consent mode by country,
- analytics provider,
- ad provider,
- affiliate programs,
- sponsored placements,
- retention periods,
- IP anonymization mode,
- whether anonymous state saving is enabled,
- whether account saving is enabled,
- whether third-party scripts are blocked before consent,
- privacy policy version,
- cookie policy version.

## Recommended User Experience

First visit:

- show clear cookie/consent banner,
- allow accept all,
- reject optional,
- configure choices,
- do not block beginner help.

When using tools:

- if no optional cookies, allow current-session use,
- offer "save this plan on this device",
- explain that saving uses a first-party cookie/local storage,
- offer account save later only when needed.

Returning visitor:

- if anonymous ID exists, restore last state,
- show "continue where you left off",
- allow clear saved data.

Privacy controls:

- manage cookie preferences,
- clear local saved plans,
- request deletion if account exists,
- disable analytics/ads.

## Advertising And Trust Rules

- Advertising must not override recommendation ranking.
- Sponsored links must be labeled.
- Affiliate links must be disclosed near the link.
- Paid placement must not look like independent editorial advice.
- If a product is recommended because it fits, explain why.
- If a product is paid/sponsored, say so plainly.
- Keep cheaper and non-affiliate alternatives visible when relevant.

## MVP Recommendation

For the first public version:

1. Use no third-party ads.
2. Use no behavioral advertising.
3. Use first-party consent storage.
4. Use anonymous local progress saving.
5. Use basic affiliate disclosure.
6. Store affiliate clicks minimally.
7. Use privacy-friendly analytics only after consent/config decision.
8. Keep IP handling limited to server/security logs.

Add advertising and paid placements only after:

- cookie policy exists,
- privacy policy exists,
- consent UI exists,
- admin controls exist,
- disclosures are tested on mobile and desktop.
