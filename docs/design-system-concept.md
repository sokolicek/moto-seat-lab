# Design System Concept

Status: concept draft

Purpose: define a configurable design direction for Moto Seat Lab before implementation starts.

The website should be friendly for beginners, trustworthy for buyers, and expandable into expert/lab tools later. The design must support multiple layouts, themes, device sizes, image modes, languages, and content depths without rebuilding every page.

## Core Design Principles

- Start simple, reveal depth gradually.
- Help the rider before showing technical complexity.
- Keep buying recommendations honest and easy to compare.
- Separate content from layout.
- Separate layout from theme.
- Separate theme from user preferences.
- Use configuration for navigation, theme, density, image mode, and language.
- Design mobile first, then expand to tablet, laptop, desktop, and large monitor.

## Brand Feel

Moto Seat Lab should feel:

- practical,
- technically credible,
- direct,
- independent,
- garage-friendly,
- beginner-safe,
- not luxury-only,
- not fake scientific.

Avoid:

- over-polished sales pages,
- generic motorcycle stock-photo feeling,
- aggressive affiliate-shop look,
- walls of expert controls on the first screen,
- fake certainty.

## Configurable Design Axes

The frontend should support these configurable choices.

### Navigation Position

Supported layouts:

- top navigation,
- left sidebar navigation,
- right utility panel,
- bottom mobile navigation,
- compact hamburger navigation,
- expert split layout with left content and right comparison/tool panel.

Recommended defaults:

- mobile: top header + bottom primary actions,
- tablet: top header + optional side drawer,
- desktop: left navigation + main content,
- large monitor: left navigation + main content + right context panel.

### Theme

Supported themes:

- light,
- dark,
- high contrast,
- garage/workshop,
- touring/clean,
- low-distraction reading mode.

Theme tokens:

- background color,
- surface color,
- text color,
- muted text color,
- border color,
- accent color,
- success/warning/danger colors,
- link color,
- chart colors,
- focus ring color.

### Typography

Configurable:

- font family,
- heading font,
- body font,
- monospace font,
- font scale,
- line height,
- content width,
- reading density.

Recommended first defaults:

- readable sans-serif body font,
- restrained headings,
- no decorative display font for technical pages,
- larger line height for article pages,
- tighter density for comparison tables and tools.

### Image Mode

Supported modes:

- rich images,
- minimal images,
- no images,
- diagrams only,
- user-uploaded/measured photos later.

Use cases:

- beginner pages should benefit from clear photos or diagrams,
- expert pages can work with diagrams and tables,
- low-bandwidth/no-image mode should preserve full usability,
- affiliate cards should never depend only on images.

### Layout Density

Supported densities:

- relaxed,
- standard,
- compact,
- expert/table mode.

Examples:

- beginner guide: relaxed,
- comparison page: standard,
- product table: compact,
- expert calculator: expert/table mode.

### Language And Locale

Configurable:

- language,
- country,
- currency,
- unit preferences,
- retailer availability,
- affiliate programs,
- legal notices,
- content depth defaults.

Initial priority:

- German for public first page,
- Slovak for working notes,
- English for project documentation.

## Responsive Layout Targets

### Small Mobile

Target examples:

- older/smaller iPhone,
- compact Android phones.

Design requirements:

- one-column layout,
- sticky top header,
- bottom action bar for primary actions,
- no wide tables,
- comparison cards instead of tables,
- collapsible sections,
- short questions,
- large tap targets,
- no hover-only interactions.

### Large Mobile

Target examples:

- modern iPhone,
- larger Android phones.

Design requirements:

- one-column content,
- optional inline comparison cards,
- sticky next-step button,
- progressive disclosure,
- image crops must not hide key motorcycle/seat details.

### Tablet

Target examples:

- iPad,
- Android tablets.

Design requirements:

- two-column layout where useful,
- side drawer or side navigation,
- comparison cards in two columns,
- article plus sticky summary possible,
- comfortable touch targets.

### Medium Desktop

Target examples:

- laptop,
- 1080p monitor.

Design requirements:

- left navigation,
- central content column,
- optional right summary panel,
- comparison tables allowed,
- calculator and results side by side when space allows.

### Large Desktop

Target examples:

- ultrawide or large external monitor.

Design requirements:

- maximum readable content width,
- avoid stretching paragraphs,
- use right rail for source notes, product comparison, or active result,
- allow expert tables and charts,
- keep primary task visually centered.

## Page Templates

### Beginner Help Page

Purpose:

- help someone who only knows the seat hurts.

Layout:

- short problem statement,
- quick guided questions,
- immediate realistic solution paths,
- optional deeper sections.

Required components:

- problem selector,
- motorcycle picker,
- ride style selector,
- budget selector,
- solution path cards,
- warnings,
- confidence indicator.

### Bike Guide Page

Purpose:

- model-specific page such as Suzuki GSX-S1000GX.

Layout:

- model summary,
- known stock seat notes,
- common complaints,
- buy-ready options,
- add-on options,
- DIY options,
- professional upholstery,
- measurements,
- sources and confidence.

### Comparison Page

Purpose:

- compare stock, OEM, aftermarket, upholsterer, add-on, and DIY.

Layout:

- comparison table on desktop,
- stacked comparison cards on mobile,
- filters for budget/use case/country,
- clear "best for" and "not ideal for".

### DIY Planner Page

Purpose:

- guide deeper users into material and modification planning.

Layout:

- step-by-step wizard,
- material stack builder,
- cost estimate,
- risk warnings,
- shopping list.

### Expert Lab Page

Purpose:

- expose advanced geometry, material, and calculation details.

Layout:

- dense controls,
- tables,
- charts,
- formula version,
- confidence/source panel.

## Component Families

Core:

- header,
- navigation,
- footer,
- language switcher,
- theme switcher,
- reading-depth switcher,
- breadcrumb,
- search.

Beginner:

- problem selector,
- pain location picker,
- ride style picker,
- budget selector,
- solution path card,
- "why this / why not this" block.

Comparison:

- product card,
- price band,
- source confidence badge,
- affiliate disclosure badge,
- fitment warning,
- comparison table,
- mobile comparison card.

Calculator:

- stepper,
- slider,
- segmented control,
- measurement input,
- confidence meter,
- warning panel,
- result summary,
- assumptions panel.

Content:

- article body,
- callout,
- source note,
- measurement guide,
- image with annotation,
- diagram,
- chart.

## Configuration Model

Future implementation should allow a file like:

```json
{
  "layout": {
    "navigation": "left",
    "rightPanel": "context",
    "density": "standard",
    "imageMode": "rich"
  },
  "theme": {
    "mode": "light",
    "accent": "technical-blue",
    "fontScale": "normal"
  },
  "locale": {
    "language": "de",
    "country": "DE",
    "currency": "EUR",
    "units": "metric"
  },
  "content": {
    "defaultDepth": "beginner",
    "showExpertSections": false,
    "showAffiliateLinks": true
  }
}
```

Do not hard-code navigation position, colors, or page density directly into content pages.

## Accessibility And Usability

Requirements:

- keyboard navigation,
- visible focus states,
- sufficient contrast,
- large touch targets,
- no information conveyed by color alone,
- all images have useful alt text,
- no hover-only controls,
- readable without images,
- comparison cards usable on mobile,
- affiliate disclosure visible near links.

## Visual Asset Strategy

Support:

- real motorcycle/seat photos,
- annotated photos,
- simple diagrams,
- material texture photos,
- product images when allowed,
- no-image fallback.

Rules:

- beginner pages need practical visuals when available,
- product photos must not replace technical comparison,
- images should be optional per layout mode,
- do not depend on copyrighted product images without permission or allowed usage.

## First MVP Design Recommendation

Start with:

- responsive static site,
- light theme,
- configurable theme tokens,
- top navigation on mobile,
- left navigation on desktop,
- rich image mode with no-image fallback,
- beginner-first home page,
- model guide template,
- comparison card component.

Avoid for MVP:

- complex user accounts,
- advanced theme editor UI,
- animated dashboards,
- heavy charting library,
- full admin UI.

## Design Done Criteria

A page design is done only when:

- it works on small mobile,
- it works on tablet,
- it works on medium desktop,
- it works on large desktop,
- it works without images,
- menu position can be changed by config,
- theme tokens can change colors and fonts,
- beginner content is not blocked by expert inputs,
- product/affiliate links remain clearly disclosed,
- important text does not overflow or overlap.
