# Video Maintenance

Videos are maintained as structured local data and seeded into PostgreSQL.

## Data Source

Edit:

```text
src/data/videos/seat-videos.json
```

Each video has two parts:

- `video_resources`: the video itself, including title, YouTube ID, thumbnail, summary and risk notes.
- `content_video_links`: links that decide where the video appears.

## Section Linking

Use `links` to attach one video to one or more places:

```json
{
  "entityType": "page_section",
  "entityKey": "de-diy-videos",
  "usage": "learning",
  "priority": 1
}
```

Current section keys:

- `de-diy-videos`: main DIY video section.
- `de-diy-schaumstoffe`: foam-specific learning section.

Other useful entity types:

- `seat_material`
- `workshop_tool`
- `workshop_supply`
- `motorcycle_profile`
- `product_category`

## Add A Video

1. Find the YouTube video ID.
2. Check basic metadata:

```powershell
.\scripts\youtube-oembed.ps1 -Url "https://www.youtube.com/watch?v=VIDEO_ID"
```

3. If needed, fetch full YouTube snippet with an API key:

```powershell
$env:YOUTUBE_API_KEY="..."
.\scripts\youtube-video-snippet.ps1 -VideoId "VIDEO_ID"
```

4. Add the curated record to `src/data/videos/seat-videos.json`.
5. Run:

```powershell
.\scripts\db-seed.ps1
.\scripts\db-check.ps1
```

## Rules

- Do not copy long YouTube descriptions into page copy.
- Always write a short Moto Seat Lab summary.
- Always add what the viewer should look for.
- Always add risk notes.
- Use `youtube-nocookie.com` for embeds.
- Keep videos lazy-loaded behind a button.
