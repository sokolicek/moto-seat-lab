# Asset Register

This file tracks local visual assets used by the Moto Seat Lab MVP.

## Hero Images

### `public/assets/hero/touring-forest-curve.webp`

- Type: AI-generated raster image.
- Purpose: German homepage hero background and social sharing image.
- Prompt summary: sport-touring motorcycle riding through a left-to-right forest road curve in a German touring context.
- Source path: generated via Codex image generation and copied into the project.
- Optimization: converted from PNG to WebP, width limited to 1920 px, quality 82.
- File size target: keep below 300 KB where practical.
- Usage:
  - `src/pages/de/index.astro`
  - CSS variable `.germany-hero`
- Constraints:
  - Do not present as a documentary photo.
  - Do not use as proof of any specific motorcycle model, place, product, or riding condition.
  - Replace with licensed photography later if the project needs real editorial imagery.

## Hero Videos

### `public/assets/video/gsx-s1000gx-forest-curve.mp4`

- Type: local MP4 video supplied by the project owner.
- Purpose: GSX-S1000GX guide hero background.
- Usage:
  - `src/pages/de/motorrad-sitzbank/suzuki-gsx-s1000gx/index.astro`
- Playback:
  - `autoplay`, `muted`, `loop`, `playsinline`.
  - No controls, because it is a decorative background.
  - Static WebP poster/fallback: `public/assets/hero/touring-forest-curve.webp`.
- Performance note:
  - Current file is suitable for local MVP validation.
  - Before public deployment, optimize to a smaller WebM/MP4 pair and keep the hero background below a practical page-weight budget.
  - Consider disabling video by default on mobile or slow connections.
