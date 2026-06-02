# Calculation Model Concept

## Goal

Define what the future site should calculate or estimate.

Important: these are guidance calculations, not medical or engineering guarantees.

## Core Outputs

The tools should produce:

- comfort risk score,
- seat height/reach risk,
- rider triangle risk,
- estimated seat load by riding scenario,
- long-distance suitability score,
- heat/sweat risk,
- braking slide risk,
- off-road impact risk,
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
- footpeg position,
- handlebar position,
- suspension sag,
- wind protection,
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

### Scenario Inputs

- city/country/highway/off-road/touring,
- average speed,
- ride duration,
- seated/standing percentage,
- road roughness,
- braking/cornering intensity,
- wind exposure,
- passenger and luggage weight,
- ambient temperature and rain use.

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

### 3. Rider Triangle Risk

Inputs:

- seat reference point,
- handlebar position,
- footpeg position,
- rider inseam,
- thigh/lower leg estimates,
- torso/arm estimates,
- seat height changes.

Outputs:

- knee angle risk,
- hip angle risk,
- forward lean estimate,
- likely wrist/neck compensation warning.

Important: lowering a seat can improve reach to ground but worsen knee angle.

### 4. Estimated Seat Load

Inputs:

- rider weight,
- passenger/luggage weight,
- motorcycle category,
- handlebar reach,
- footpeg drop and rearward offset,
- seat slope,
- wind exposure,
- riding scenario,
- seated/standing percentage.

Outputs:

- estimated static seat load,
- highway load score,
- footpeg support tendency,
- hand/wrist support tendency,
- confidence level.

Early formula concept:

```text
estimated_seat_load = rider_weight * posture_seat_load_factor
```

The factor must be configured by scenario and posture. Early versions should use broad bands, not precise numbers.

Scenario notes:

- highway riding can increase rearward pressure when wind pushes the rider into the seat step,
- cruise control can increase seated load because the rider supports less weight through arms,
- sporty forward lean may reduce seat load but increase wrist and neck fatigue,
- off-road standing greatly reduces seated load, but seated impacts can be high,
- passenger and luggage change rear sag and seat slope.

### 5. Pressure Risk

Inputs:

- rider weight,
- sit bone distance,
- seat support width,
- foam firmness,
- foam compression behavior,
- estimated seat load,
- ride duration.

Outputs:

- pressure risk estimate,
- warning if seat is too narrow or too soft.

### 6. Braking Slide Risk

Inputs:

- seat fore-aft slope,
- cover friction,
- rider posture,
- braking intensity,
- tank shape/contact,
- riding pants friction.

Outputs:

- low/medium/high slide risk,
- warning if a softer or higher top layer may make sliding worse.

### 7. Off-Road And Bad-Road Impact Risk

Inputs:

- road roughness,
- suspension travel,
- suspension sag,
- seat foam stack,
- seated percentage,
- rider weight,
- motorcycle category.

Outputs:

- impact comfort risk,
- bottoming-out risk,
- recommendation for support layer vs soft top layer.

### 8. Heat And Sweat Risk

Inputs:

- climate,
- material,
- cover,
- ride duration.

Outputs:

- heat risk,
- recommendation for mesh/breathable materials.

### 9. Long-Distance Suitability

Inputs:

- ride duration target,
- pressure risk,
- heat risk,
- seat width,
- rider triangle risk,
- estimated seat load,
- material stack,
- passenger use.

Outputs:

- long-distance suitability score,
- recommended intervention level.

### 10. DIY Difficulty

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

### 11. Budget Fit

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
