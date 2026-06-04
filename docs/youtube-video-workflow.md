# YouTube Video Workflow

Moto Seat Lab can use YouTube videos as curated learning references, but the site should not become a random video dump.

## Playback

YouTube videos can be played directly on the page with an iframe embed:

```html
<iframe src="https://www.youtube-nocookie.com/embed/VIDEO_ID"></iframe>
```

Use the privacy-enhanced `youtube-nocookie.com` domain by default. Do not download YouTube videos or host copies locally.

## Metadata Options

### oEmbed, no API key

Use for quick checks:

```powershell
.\scripts\youtube-oembed.ps1 -Url "https://www.youtube.com/watch?v=VIDEO_ID"
```

Returns useful preview data such as title, channel/author, thumbnail and embed HTML. It does not return the full YouTube description.

### YouTube Data API, API key required

Use when we need the real video description, duration, tags or embeddable status:

```powershell
$env:YOUTUBE_API_KEY="..."
.\scripts\youtube-video-snippet.ps1 -VideoId "VIDEO_ID"
```

Never commit the API key. Store only curated metadata in `src/data/videos/seat-videos.json`.

## Editorial Fields To Store

For every video, store:

- YouTube video ID and original URL.
- Title, channel, language and duration.
- Short fetched description or source excerpt.
- Moto Seat Lab editorial summary.
- What the user should look for in the video.
- Risk notes and whether the video is beginner-safe.
- Embed status: allowed, blocked, unknown or pending review.

## Review Rules

- Embed only public videos where YouTube embedding works.
- Prefer videos that explain principles rather than selling one product.
- Do not copy long YouTube descriptions into page text.
- Keep the YouTube player visible as a YouTube player; do not hide branding or controls.
- For cookie/privacy UX, lazy-load the iframe behind a user action where practical.

## First Curated Videos

- `o_hUdHW6Opk`: Alchemy Kustom seat-foam shaping. Embed URL returns HTTP 200. Metadata is curated from The Hog Ring source context because oEmbed returned Forbidden during local validation.
- `RMroBU_yUA8`: Motea gel-pad installation. Embed URL returns HTTP 200. Metadata is curated from Green Line's gel-installation source page because oEmbed returned Forbidden during local validation.
- `_1BSj2Vnwj0`: HTMotoFilms DIY Custom Motorcycle Seat & Gel Installation. oEmbed returned title, channel and thumbnail; embed URL returns HTTP 200.
