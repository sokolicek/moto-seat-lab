# Media Asset Workflow

Moto Seat Lab stores every public image as a tracked media asset. The goal is to avoid anonymous images, unclear licenses, unstable remote hotlinks, and layout jumps.

## Files

- `src/data/media/media-assets.json` is the source of truth for image metadata.
- `public/assets/media/` contains downloaded local image files used by the website.
- `scripts/download-media-assets.ps1` downloads active assets from their `downloadUrl`.
- `src/components/MediaAssetFigure.astro` renders images with stable sizing and optional attribution.
- `src/lib/mediaAssets.ts` resolves images by `entityType`, `entityKey`, and `usage`.
- `db/schema.sql` stores media assets in `media_assets` and entity links in `content_media_links`.
- `/de/admin/assets/` shows the local asset register, including blocked manufacturer-image placeholders.

## Required Metadata

Every image needs:

- `key`: stable internal identifier.
- `localPath`: public path used by Astro, for example `/assets/media/example.jpg`.
- `downloadUrl`: source file URL used by `make media-download`.
- `sourcePageUrl`: human-readable source page for review and attribution.
- `creator`: photographer, uploader, manufacturer, or rights holder when known.
- `licenseName`, `licenseCode`, `licenseUrl`: license metadata.
- `rightsStatus`: short internal rights summary.
- `attributionRequired`: whether the website must show credit next to the image.
- `creditLine`: visible credit line when attribution is required.
- `alt`: accessible image description.
- `aspectRatio`: stable display ratio, such as `16 / 9`, `4 / 3`, or `3 / 2`.
- `links`: entity bindings for use on cards, sections, heroes, or future modules.

## Safe Rights Statuses

- `usable_with_attribution`: can be used commercially, credit must be shown.
- `usable_with_attribution_sharealike`: can be used commercially, credit must be shown, modified derivatives may need compatible licensing.
- `usable_without_required_attribution`: can be used commercially, attribution is optional but still useful in the asset register.
- `placeholder_only`: local placeholder or illustration, not a real product image.
- `permission_needed`: do not show publicly until written permission or an official API license exists.

`permission_needed` records may stay in the database as planning entries, but public page helpers only return active assets.

## Adding A New Image

1. Confirm the source license before download.
2. Add a new entry to `src/data/media/media-assets.json`.
3. Use a clear local filename under `/assets/media/`.
4. Add at least one `links` entry, for example:

```json
{ "entityType": "seat_material", "entityKey": "anti_slip_cover", "usage": "card", "priority": 1 }
```

5. Run `make media-download`.
6. Run `make db-seed`.
7. Run `make db-check`.
8. Run `npm run check` and `npm run build`.

## Display Rules

- Use `MediaAssetFigure.astro` instead of raw `<img>` when the image comes from the media registry.
- Use `aspectRatio` and `objectPosition` to keep card dimensions stable.
- Show attribution near the image when `attributionRequired` is true.
- Do not hotlink external images in public pages.
- Do not use manufacturer product photos unless `rightsStatus` is changed from `permission_needed` after permission, press-kit terms, or affiliate API rights are documented.

## First Registered Sources

- Wikimedia Commons: motorcycle seats at Camden Town, Honda Goldwing detail, leather material sample.
- Pexels: forest curve motorcyclist.
- Unsplash: touring motorcycle beside road.
