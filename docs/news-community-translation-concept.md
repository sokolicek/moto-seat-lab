# News, Community, Source Directory, And Translation Concept

Status: concept draft

Purpose: define how Moto Seat Lab can later show motorcycle-seat-related news, external forum links, rider feedback, mini forum/community notes, and country/language-specific translations while keeping everything configurable by the administrator.

This should be an optional layer. The first website can launch without it, but the architecture should be ready for it.

## Goals

- Show relevant motorcycle seat and comfort news from configured sources.
- Maintain a directory of forums, websites, shops, upholsterers, and communities where motorcycle seats are discussed.
- Allow visitors to leave feedback, notes, links, and practical experience.
- Support a lightweight mini forum or moderated comment system later.
- Support country-specific and language-specific views.
- Support translation into the selected language, for example Slovak when the user selects Slovakia/Slovak.
- Keep the administrator in control of sources, categories, moderation, translation, and publishing.

## What This Is Not

This should not become an uncontrolled scraped news site.

Avoid:

- copying full articles from other websites,
- auto-publishing unreviewed external content,
- presenting forum posts as verified facts,
- allowing spammy affiliate comments,
- building a large social network too early,
- requiring user accounts in the first version.

Use links, summaries, source notes, and moderation.

## Admin-Configurable Sources

The administrator should be able to define source records.

Source types:

- motorcycle news website,
- motorcycle forum,
- brand/manufacturer news page,
- aftermarket manufacturer blog/news,
- retailer blog,
- upholsterer website,
- Reddit/community page,
- YouTube channel,
- product review site,
- owner club,
- local language community,
- manual/admin-added source.

Fields:

- source name,
- source type,
- website URL,
- RSS/feed URL if available,
- country,
- language,
- topic categories,
- seat comfort relevance,
- allowed use: link only / summarize manually / import title and snippet,
- crawl/feed enabled,
- translation enabled,
- moderation required,
- trust level,
- last checked date,
- notes.

## News Item Model

Each news item should store:

- title_original,
- title_translated,
- summary_original,
- summary_translated,
- source_id,
- source_url,
- canonical_url,
- original_language,
- target_language,
- country relevance,
- motorcycle model relevance,
- seat/material/review/category tags,
- publication date,
- discovered date,
- translation status,
- moderation status,
- copyright mode,
- confidence level,
- admin notes.

Copyright modes:

- link-only,
- short-summary,
- manual-summary,
- original-content,
- user-submitted.

## External Forum And Website Directory

The site should have curated pages such as:

```text
Where riders discuss motorcycle seat comfort
Best forums for Suzuki GSX-S1000GX seat comfort
German motorcycle seat upholstery resources
Aftermarket motorcycle seat makers by country
```

Directory entry fields:

- name,
- type,
- URL,
- country,
- language,
- motorcycle brands/models discussed,
- seat topics,
- registration required,
- quality/trust notes,
- moderation notes,
- last verified date.

Important:

- forum links are discovery sources, not proof,
- each page should label forum data as anecdotal,
- direct copying of user posts should be avoided unless permission/license allows it.

## Feedback And Mini Forum

Start small.

Phase 1:

- feedback form,
- "submit a seat experience",
- "submit a link",
- "report wrong product fitment",
- "suggest a shop/upholsterer",
- admin moderation queue.

Phase 2:

- moderated comments under bike guides,
- model-specific experience reports,
- rating dimensions,
- photo upload with approval,
- spam protection.

Phase 3:

- mini forum or discussion threads,
- user profiles,
- reputation/trust markers,
- verified owner reports.

Feedback fields:

- user display name,
- email optional/private,
- country,
- language,
- motorcycle brand/model/year,
- seat type,
- ride duration before pain,
- solution tried,
- result,
- cost,
- link/source,
- permission to publish,
- moderation status,
- admin notes.

## Translation Strategy

The site should support multiple translation modes.

### Mode 1: Native Content

Best for core pages.

Example:

- German Suzuki GSX-S1000GX guide written and edited directly in German.
- Slovak version written or edited directly in Slovak.

### Mode 2: Admin-Approved Machine Draft

Useful for expanding countries/languages.

Flow:

1. Source content exists in primary language.
2. Machine translation creates draft.
3. Administrator reviews and edits.
4. Only approved translation is published.

### Mode 3: On-Demand Translation Link

Useful for external news and forum links.

Example:

```text
Original article: German
View summary in Slovak
Open original source
Open translated view
```

### Mode 4: Short Localized Summary

For external sources, prefer a short summary in the user's language plus a link to the source.

Do not republish full external articles.

## Country Behavior Example

If the user selects Slovakia/Slovak:

- interface language: Slovak,
- currency: EUR,
- units: metric,
- show Slovak summaries where available,
- show German/Czech/Polish/Austrian sources when relevant,
- label original source language,
- offer translated summaries or links,
- prioritize shops that ship to Slovakia,
- show affiliate links valid for Slovakia when available.

If the user selects Germany/German:

- interface language: German,
- country-specific retailers,
- German forums and shops first,
- German legal/affiliate disclosure,
- German product availability.

## Admin Controls

Administrator should be able to configure:

- enabled countries,
- enabled languages,
- default language per country,
- source list,
- feed polling on/off,
- manual-only sources,
- translation enabled per source,
- publication workflow,
- moderation queue,
- blocked domains,
- trusted domains,
- affiliate domains,
- max summary length,
- whether comments are allowed,
- whether anonymous feedback is allowed,
- spam protection level.

## Publishing Workflow

Recommended workflow:

```text
Discover source item
Classify topic
Check duplicate
Create short summary
Translate summary if needed
Mark source and confidence
Admin approves
Publish in news/source directory
```

For user feedback:

```text
User submits feedback
Spam check
Admin moderation
Optional translation
Publish as experience report or keep private research note
```

## UI Concepts

### News Page

Filters:

- country,
- language,
- motorcycle model,
- topic,
- source type,
- confidence,
- date.

Cards should show:

- title,
- short summary,
- source,
- original language,
- translated summary availability,
- topic tags,
- open original link,
- confidence/moderation status.

### Source Directory Page

Sections:

- forums,
- news websites,
- manufacturers,
- aftermarket brands,
- upholsterers,
- shops,
- review sources,
- owner clubs.

### Feedback Page

Beginner-friendly prompt:

```text
Tell us what seat you have, what hurt, what you tried, and whether it helped.
```

No expert measurements required.

### Admin Page

Sections:

- sources,
- news queue,
- feedback queue,
- translations,
- blocked/spam items,
- published items,
- source health.

## Data Model Additions

Future entities:

- `content_source`
- `source_check`
- `news_item`
- `external_link`
- `forum_directory_entry`
- `user_feedback`
- `experience_report`
- `comment_thread`
- `comment`
- `translation_job`
- `translated_content`
- `moderation_event`
- `admin_setting`

## Risks

- copyright issues if too much external content is copied,
- spam in feedback/forum features,
- low-quality machine translations,
- stale external links,
- affiliate bias,
- moderation workload,
- legal requirements around user-generated content.

## Recommended MVP Path

Do not build full news/forum first.

Recommended order:

1. Manual source directory.
2. Manual news/link notes curated by admin.
3. Feedback form with moderation.
4. Admin-managed translated summaries.
5. RSS/feed discovery only after moderation workflow exists.
6. Mini forum only after there is real community demand.

This keeps the project useful without becoming a moderation and scraping problem too early.
