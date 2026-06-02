# Calculation Model Concept

## Goal

Define what the future site should calculate or estimate.

Important: these are guidance calculations, not medical or engineering guarantees.

## Core Outputs

The tools should produce:

- comfort risk score,
- seat height/reach risk,
- long-distance suitability score,
- heat/sweat risk,
- DIY difficulty score,
- estimated cost range,
- recommended solution path,
- warnings and assumptions.

## Input Groups

### Rider Inputs

- age,
- height,
- weight,
- inseam,
- sit bone distance,
- pain location,
- pain start time,
- target ride duration,
- DIY skill,
- budget.

### Motorcycle Inputs

- motorcycle category,
- stock seat height,
- seat width,
- bike weight,
- riding position,
- passenger/luggage use.

### Seat Inputs

- stock seat dimensions,
- aftermarket seat dimensions,
- planned material layers,
- layer thickness,
- material firmness,
- cover type,
- heating,
- waterproofing.

## Proposed Calculations

### 1. Seat Height Delta

```text
new_seat_height = stock_seat_height + added_layer_height - removed_foam_height
```

Output:

- new estimated seat height,
- warning if reach to ground becomes risky.

### 2. Reach-To-Ground Risk

Inputs:

- rider inseam,
- new seat height,
- motorcycle category,
- boot sole estimate.

Outputs:

- low / medium / high risk.

Important: seat width affects reach, not only height.

### 3. Pressure Risk

Inputs:

- rider weight,
- sit bone distance,
- seat support width,
- foam firmness,
- ride duration.

Outputs:

- pressure risk estimate,
- warning if seat is too narrow or too soft.

### 4. Heat And Sweat Risk

Inputs:

- climate,
- material,
- cover,
- ride duration.

Outputs:

- heat risk,
- recommendation for mesh/breathable materials.

### 5. Long-Distance Suitability

Inputs:

- ride duration target,
- pressure risk,
- heat risk,
- seat width,
- material stack,
- passenger use.

Outputs:

- long-distance suitability score,
- recommended intervention level.

### 6. DIY Difficulty

Inputs:

- selected modification type,
- heating,
- cover sewing,
- foam cutting,
- waterproofing,
- tools available.

Outputs:

- beginner/intermediate/advanced,
- warning if professional work is recommended.

### 7. Budget Fit

Inputs:

- user budget,
- material plan,
- tool requirements,
- professional labor estimate,
- aftermarket seat price.

Outputs:

- under budget,
- near budget,
- over budget,
- lower-cost alternatives.

## Solution Recommendation Logic

Example:

```text
If pain_start < 60 min and DIY_skill = beginner:
  recommend reversible add-ons first.

If target_ride_duration > 180 min and pressure_risk = high:
  recommend professional reshaping or custom seat.

If seat_height_risk = high:
  warn against thick add-on layers.

If heat_risk = high:
  prioritize 3D mesh/breathable cover.
```

## Formula Storage

Recommended:

- calculation functions live in code,
- thresholds and coefficients live in config/database,
- each output includes `formula_version`,
- each recommendation includes assumptions.

Example configuration:

```json
{
  "rule_key": "reach_to_ground_risk",
  "version": "0.1",
  "thresholds": {
    "low_margin_mm": 80,
    "medium_margin_mm": 40,
    "high_margin_mm": 0
  }
}
```

## Missing Data Strategy

If data is missing:

- ask user to enter it,
- use a conservative estimate,
- mark confidence as low,
- avoid strong recommendations.

## Safety Notes

The system should always show safety notes when:

- seat height changes,
- seat is made slippery,
- heating is added,
- waterproofing is modified,
- passenger section is modified,
- seat lock/base is changed.

