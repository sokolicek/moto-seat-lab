# Implementation Notes For Future Development

## What Should Be In The Database

Store:

- motorcycle records,
- stock seat records,
- aftermarket seat records,
- material records,
- retailer records,
- affiliate programs,
- product categories,
- country/language data,
- calculation thresholds,
- formula coefficients,
- formula version metadata,
- source URLs,
- confidence levels,
- last verification date.

## What Should Be In Code

Keep in versioned code:

- calculation function structure,
- validation logic,
- safety warnings,
- unit conversion,
- input normalization,
- recommendation pipeline.

Avoid storing arbitrary executable formulas in the database at the beginning. It is safer to store parameters and thresholds, then use reviewed code to calculate.

## What Should Be Configurable

Good candidates:

- risk thresholds,
- score weights,
- country-specific price ranges,
- material coefficients,
- rider category thresholds,
- budget ranges,
- affiliate product category mappings,
- warning text variants.
- navigation position,
- theme tokens,
- font family and scale,
- layout density,
- image mode,
- content depth defaults,
- locale and unit preferences.

## Design Configuration Principles

The future frontend should not hard-code visual decisions into content pages.

Keep configurable:

- top/left/right/bottom navigation variants,
- mobile/tablet/desktop layout variants,
- light/dark/high-contrast themes,
- image-rich and no-image modes,
- beginner/advanced/expert content depth,
- font choices,
- chart colors,
- page density.

Recommended approach:

- define design tokens in configuration,
- map page templates to layout variants,
- keep content as structured data or markdown,
- keep product cards and comparison tables as reusable components,
- make no-image mode a first-class layout option,
- test small mobile, large mobile, tablet, laptop, desktop, and large monitor layouts before considering a page done.

## Data Quality Levels

Each data point should be marked:

```text
verified
manufacturer_spec
measured_by_owner
retailer_claim
forum_anecdote
estimated
unknown
```

The site should show confidence where recommendations depend on uncertain data.

## Measurement Inputs To Support

### Rider

- height,
- weight,
- inseam,
- sit bone distance,
- hip width estimate,
- boot sole height,
- pain location,
- pain start time.

### Motorcycle

- stock seat height,
- seat width front/middle/rear,
- seat slope,
- rider triangle notes,
- wet weight,
- suspension sag if known.

### Seat

- foam thickness,
- added layer thickness,
- removed foam thickness,
- material type,
- cover type,
- heating element thickness,
- waterproof layer.

## Things Easy To Forget

- seat width affects ground reach, not only seat height,
- soft foam can increase pressure over time if support collapses,
- gel can retain heat,
- air cushions can feel unstable,
- 3D mesh helps ventilation but raises seat slightly,
- heating needs safe wiring and waterproofing,
- passenger comfort can change when rider seat changes,
- topcase can change passenger posture,
- lowering a seat may reduce long-distance comfort,
- slippery covers can reduce control,
- seams can create pressure points,
- waterproofing failure can ruin foam,
- original seat resale value matters,
- buying a spare used seat can make DIY safer.

## Legal And Safety Notes

The website should include:

- affiliate disclosure,
- safety disclaimer,
- no medical advice disclaimer,
- no guarantee of fitment,
- warning about electrical heating modifications,
- warning about warranty and insurance implications,
- reminder to test safely before long trips.

## Future Admin Interface

Possible admin features:

- edit motorcycle data,
- edit seat data,
- edit materials,
- edit calculation thresholds,
- add product categories,
- mark data verification status,
- add source links,
- publish/unpublish bike guides.

## First Technical MVP Recommendation

Do not start with a complex app.

Recommended order:

1. Static content site.
2. JSON/YAML structured data.
3. Simple calculators in frontend code.
4. Database only after data model stabilizes.
5. Admin/config UI later.
