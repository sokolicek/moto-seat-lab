# Maintenance Workflow

## Goal

Keep motorcycle and seat data accurate enough for useful comparisons and recommendations.

## Roles

### Researcher

Finds official specs, product pages, owner measurements, reviews, and forum reports.

Outputs:

- source links,
- extracted data,
- notes,
- confidence suggestion.

### Data Editor

Creates or updates structured records.

Outputs:

- motorcycle records,
- seat records,
- material records,
- source records.

### Validator

Checks:

- required fields,
- source quality,
- compatibility,
- duplicate records,
- units,
- confidence levels.

### Publisher

Approves records for public use.

Outputs:

- published comparison tables,
- public bike guides,
- product category sections.

## Add New Motorcycle Workflow

```text
1. Create motorcycle draft.
2. Add official source.
3. Add stock seat baseline.
4. Add known variants and model years.
5. Add country relevance.
6. Add known seat complaints.
7. Add OEM optional seats.
8. Add aftermarket seats.
9. Validate required data.
10. Approve for public guide.
```

## Update Existing Motorcycle Workflow

```text
1. Check if model year changed.
2. Check if accessories changed.
3. Check if aftermarket compatibility changed.
4. Update sources and date_checked.
5. Recalculate comparison outputs.
6. Review public page warnings.
```

## Add Aftermarket Seat Workflow

```text
1. Confirm brand and product name.
2. Confirm compatibility.
3. Capture source URL.
4. Add price and country availability.
5. Add height/width/material data if available.
6. Mark missing measurements.
7. Assign confidence.
8. Approve or leave as research note.
```

## Validation Checklist

- Required fields are filled.
- Units are explicit.
- Source URL exists.
- Compatibility is model/year specific.
- Price has currency.
- Country availability is explicit.
- Confidence matches source quality.
- No duplicate part number/product URL.
- Public text does not overclaim.

## Maintenance Schedule

Suggested:

- review key bike pages every 6 months,
- review affiliate product links every 3 months,
- review prices every 3 months,
- review official model updates yearly,
- mark unavailable products as deprecated.

## Data Lifecycle

```text
draft
needs_source
needs_measurement
needs_review
approved
published
deprecated
```

## Publication Rule

Only `approved` or `published` data can power recommendation tables.

Low-confidence data can appear only as:

```text
research note
owner report
unverified option
```

