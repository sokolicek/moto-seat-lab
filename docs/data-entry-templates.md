# Data Entry Templates

These templates define the shape of records that the future data maintenance tool should support.

## Motorcycle Template

```yaml
id: suzuki-gsx-s1000gx-2024
brand: Suzuki
model: GSX-S1000GX
generation: first
year_from: 2024
year_to:
category: sport_touring_crossover
markets:
  - Germany
status: draft
research_status: needs_official_specs
technical:
  stock_seat_height_mm:
    value:
    source_id:
    confidence: 0
  wet_weight_kg:
    value:
    source_id:
    confidence: 0
notes:
  riding_position:
  passenger:
  luggage:
sources: []
```

## Stock Seat Template

```yaml
id: suzuki-gsx-s1000gx-stock-seat
motorcycle_id: suzuki-gsx-s1000gx-2024
type: oem_stock
brand: Suzuki
name: Stock seat
compatible_years:
  from: 2024
  to:
measurements:
  seat_height_mm:
    value:
    source_id:
    confidence: 0
  width_front_mm:
    value:
    source_id:
    confidence: 0
  width_mid_mm:
    value:
    source_id:
    confidence: 0
  width_rear_mm:
    value:
    source_id:
    confidence: 0
properties:
  heating: false
  waterproof_claim:
  passenger_section:
comfort_notes:
known_complaints: []
sources: []
status: draft
```

## OEM Optional Seat Template

```yaml
id:
motorcycle_id:
type: oem_optional
brand:
name:
part_number:
compatible_years:
  from:
  to:
price:
  amount:
  currency:
  country:
height_delta_vs_stock_mm:
heating:
passenger_option:
claimed_benefit:
source_id:
confidence:
status: draft
```

## Aftermarket Seat Template

```yaml
id:
motorcycle_id:
type: aftermarket
brand:
name:
product_url:
compatible_years:
  from:
  to:
available_countries: []
price:
  min:
  max:
  currency:
measurements:
  height_delta_vs_stock_mm:
  width_front_mm:
  width_mid_mm:
  width_rear_mm:
properties:
  heating_option:
  passenger_option:
  cover_material:
  waterproof_claim:
  return_policy:
confidence:
sources: []
status: draft
```

## Source Template

```yaml
id:
type: manufacturer_official
title:
url:
publisher:
country:
language:
date_checked:
notes:
confidence_contribution:
```

## Material Template

```yaml
id:
name:
category:
typical_thickness_mm:
density:
firmness:
heat_behavior:
water_behavior:
durability:
diy_difficulty:
price_range:
  min:
  max:
  currency:
sources: []
status: draft
```

## Product Category Template

```yaml
id:
name:
problem_solved:
best_for:
not_good_for:
price_range:
  min:
  max:
  currency:
diy_difficulty:
affiliate_candidate:
country_availability: []
notes:
sources: []
```

