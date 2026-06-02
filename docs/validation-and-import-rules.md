# Validation And Import Rules

## Purpose

Technical motorcycle and seat data must be consistent, traceable, and safe to use in comparisons.

The maintenance tool should reject or warn about incomplete, ambiguous, or low-confidence records.

## Required Field Validation

### Motorcycle

Required:

- brand,
- model,
- year range,
- category,
- at least one source,
- research status.

Warnings:

- missing stock seat height,
- missing wet weight,
- missing country relevance,
- no official source.

### Seat Option

Required:

- motorcycle compatibility,
- seat type,
- brand/name,
- compatible years,
- source,
- confidence level.

Warnings:

- missing price,
- missing dimensions,
- missing height delta,
- missing country availability,
- missing return policy for aftermarket products.

### Source

Required:

- URL,
- source type,
- title or short label,
- date checked,
- language,
- confidence contribution.

## Unit Rules

All values must be stored with canonical units:

- length: millimeters,
- weight: kilograms,
- price: amount + ISO currency,
- dates: ISO date,
- country: ISO country code plus display label.

Display units can be localized later.

## Compatibility Rules

Seat compatibility must specify:

- motorcycle brand,
- model,
- generation or model code if known,
- year_from,
- year_to,
- market/country if fitment differs.

Do not mark compatibility as global unless a source explicitly supports it.

## Confidence Rules

Confidence cannot be higher than source quality.

Examples:

- official manufacturer spec can be confidence 5,
- aftermarket manufacturer product page can be 4,
- reputable retailer can be 3-4,
- forum owner measurement can be 2-3,
- single forum opinion can be 1-2,
- estimate is 1.

## Duplicate Rules

Potential duplicates:

- same motorcycle brand/model/year range,
- same aftermarket brand + product name,
- same part number,
- same source URL,
- same retailer SKU.

The tool should show a merge/ignore decision instead of silently creating duplicates.

## Import Preview

Every import should show:

- rows to create,
- rows to update,
- duplicate candidates,
- validation errors,
- missing required sources,
- low-confidence warnings.

No import should publish records automatically.

## Error Levels

### Error

Blocks save/import:

- missing required brand/model,
- missing compatibility for seat,
- invalid unit,
- invalid URL,
- missing confidence,
- invalid year range.

### Warning

Allows save but blocks public publish:

- missing dimension,
- missing price,
- low confidence,
- source older than review threshold,
- no official source.

### Note

Informational:

- data is anecdotal,
- product is country-specific,
- price may change,
- compatibility needs owner confirmation.

## Calculated Field Rules

Do not manually enter values that can be calculated unless needed.

Examples:

- `height_delta_vs_stock_mm` can be calculated if stock and option height are known.
- `estimated_final_height_mm` can be calculated from seat layers.
- `budget_total` can be calculated from materials/tools.

Manual overrides should require:

- reason,
- source,
- updated_by,
- date.

## Publication Rules

Public comparison tables can use:

- approved data,
- published data.

Public research notes can use:

- low-confidence data,
- anecdotal data,
- incomplete data.

But low-confidence data must be labeled.

