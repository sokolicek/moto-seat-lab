# Calculation Input Skeleton

Status: concept draft

Purpose: define which parameters are needed for Moto Seat Lab calculations and split them into basic, additional, and special input levels.

The goal is progressive data entry:

- basic inputs should be enough for immediate beginner help,
- additional inputs improve confidence and personalization,
- special inputs support advanced calculations, measured bikes, and expert/maintenance workflows.

The first user should not be forced into expert mode. If the user only knows "my original seat hurts after one hour", the tool should still produce useful next steps.

## Level 1: Basic Parameters

These are the minimum fields for the first public calculator. They should feel like a short guided conversation, not a technical form.

### Problem

- current_seat_problem
- pain_start_minutes
- pain_location_simple
- seat_feels_too_hard
- seat_feels_too_soft
- sliding_forward
- heat_discomfort
- numbness_or_pressure

### Goal

- target_ride_duration_minutes
- main_goal
- preferred_solution_style
- budget_level

Recommended values for `preferred_solution_style`:

- buy-ready
- professional-upholsterer
- reversible-add-on
- DIY
- not-sure

### Motorcycle

- brand
- model
- year
- current_seat_is_original
- country

If the bike is known in the database, the system should fill in:

- motorcycle_category,
- stock_seat_height_mm,
- wet_weight_kg,
- riding_position_category,
- known OEM and aftermarket options.

### Use Case

- main_use_case
- typical_ride_duration_minutes
- highway_use_simple
- country_road_use_simple
- city_use_simple
- offroad_use_simple
- solo_or_passenger
- luggage_use
- season_or_temperature_range

### Basic Outputs

- likely problem category
- first realistic recommendation
- buy-ready options if available
- professional/custom option category
- reversible quick fixes
- DIY path only if the user wants it
- expensive-option warning
- fit-for-use warning
- approximate cost bands
- source and affiliate disclosure
- missing data list
- confidence level

### Beginner Example

Input:

```text
Suzuki GSX-S1000GX, original seat, pain after one hour, mostly longer trips, wants to buy rather than build.
```

Output:

```text
Show stock baseline, OEM premium/low seat if available, aftermarket options if verified, professional rebuild path, and reversible comfort tests.
Warn that a low seat may reduce foam and worsen knee comfort.
Do not ask for foam ILD, rider triangle coordinates, or sag yet.
```

## Level 2: Additional Parameters

These fields improve the calculation and should be used for registered users, saved profiles, detailed bike pages, or serious DIY planning.

### Rider Body Detail

- sit_bone_distance_mm
- hip_width_cm
- torso_length_cm
- arm_length_cm
- thigh_length_cm
- lower_leg_length_cm
- boot_sole_height_mm
- riding_pants_type
- weight_distribution_notes

### Pain And Comfort Detail

- tailbone_pain
- sit_bone_pain
- inner_thigh_pressure
- numbness
- lower_back_pain
- knee_pain
- hip_pain
- wrist_or_neck_fatigue
- pain_left_right_symmetry
- pain_after_braking
- pain_after_highway
- pain_after_bad_roads

### Motorcycle Detail

- payload_capacity_kg
- wheelbase_mm
- front_suspension_travel_mm
- rear_suspension_travel_mm
- preload_setting
- rider_sag_estimate_mm
- wind_protection_level
- cruise_control
- topcase_use
- pannier_use
- passenger_weight_kg
- luggage_weight_kg

### Rider Triangle Detail

- seat_to_footpeg_drop_mm
- footpeg_rearward_offset_mm
- handlebar_reach_category
- handlebar_height_category
- knee_angle_estimate
- hip_angle_estimate
- forward_lean_estimate

### Seat Detail

- measured_seat_width_front_mm
- measured_seat_width_sit_bone_zone_mm
- measured_seat_width_mid_mm
- measured_seat_width_rear_mm
- usable_rider_length_mm
- fore_aft_slope_deg
- side_drop_angle_deg
- seat_pocket_depth_mm
- step_to_passenger_mm
- cover_material
- cover_friction_dry
- cover_friction_wet
- seam_pressure_risk
- heating_available
- waterproof_claim

### Material Detail

- top_layer_material
- support_layer_material
- foam_thickness_mm
- gel_thickness_mm
- mesh_thickness_mm
- cover_thickness_mm
- foam_firmness_category
- foam_density_kg_m3
- planned_added_height_mm
- planned_removed_foam_mm

### Additional Outputs

- estimated new seat height
- effective width penalty for reach
- knee angle risk
- hip angle risk
- sliding risk
- braking slide risk
- highway load score
- bad-road impact risk
- DIY difficulty score
- estimated cost range
- recommended material stack direction

## Level 3: Special Parameters

These are not required for normal users. They are for deep testing, verified bike entries, professional upholsterer profiles, advanced comparison pages, or future lab-style measurements.

### Coordinate Geometry

- coordinate_system_definition
- seat_reference_point_x_mm
- seat_reference_point_y_mm
- seat_reference_point_z_mm
- lowest_seat_point_x_mm
- lowest_seat_point_y_mm
- lowest_seat_point_z_mm
- handlebar_grip_x_mm
- handlebar_grip_y_mm
- handlebar_grip_z_mm
- footpeg_x_mm
- footpeg_y_mm
- footpeg_z_mm
- passenger_peg_x_mm
- passenger_peg_y_mm
- passenger_peg_z_mm

### Advanced Seat Shape

- support_area_cm2
- pressure_zone_width_mm
- crown_radius_estimate
- longitudinal_profile_points
- lateral_profile_points
- foam_depth_map
- seat_pan_clearance_map
- seat_pan_flex_estimate
- seat_lock_clearance
- under_seat_electrical_clearance

### Suspension And Dynamics

- measured_rider_sag_mm
- measured_two_up_sag_mm
- suspension_setting_profile
- front_rear_weight_distribution
- braking_weight_transfer_estimate
- acceleration_weight_transfer_estimate
- road_roughness_profile
- seated_impact_frequency
- standing_percentage_by_scenario

### Aerodynamics

- windscreen_height_mm
- windscreen_angle
- windscreen_adjustment_position
- torso_wind_pressure_category
- helmet_buffeting_notes
- highway_posture_notes

### Material Technical Specs

- foam_ild_25_percent
- foam_ild_40_percent
- compression_set
- rebound_resilience
- tensile_strength
- elongation
- tear_strength
- operating_temperature_range
- water_absorption
- breathability_rating
- gel_durometer
- gel_heat_retention_score
- cover_uv_resistance
- cover_abrasion_resistance
- adhesive_heat_resistance
- adhesive_open_time
- adhesive_cure_time

### Measurement Metadata

- measured_by
- measured_at
- measurement_tool
- measurement_method
- source_url
- source_type
- confidence_level
- data_license
- last_verified_at

### Special Outputs

- estimated seat load kg with confidence band
- pressure distribution estimate
- posture load distribution estimate
- material bottom-out risk
- two-up sag comfort risk
- highway rearward pressure risk
- off-road seated impact risk
- formula version trace
- source confidence report

## Recommended Form Structure

### Step 1: Quick Rider Profile

Ask only:

- height,
- weight,
- inseam,
- pain start time,
- pain location,
- target ride duration.

### Step 2: Bike And Use

Ask:

- brand/model/year,
- riding style,
- typical use,
- solo/passenger,
- luggage,
- highway/city/country/off-road split.

### Step 3: Current Seat Problem

Ask:

- too hard,
- too soft,
- sliding,
- heat,
- numbness,
- tailbone pain,
- knee/hip/wrist/neck issues.

### Step 4: Optional Measurements

Offer advanced users:

- sit bone distance,
- seat width,
- seat slope,
- footpeg drop,
- handlebar reach,
- sag.

### Step 5: DIY Or Buy Preference

Ask:

- budget,
- DIY skill,
- tools available,
- willingness to cut foam,
- preference for reversible solution,
- interest in OEM, aftermarket, upholsterer, or DIY.

## First Calculator Recommendation

For version 0.1, use only Level 1 plus a few optional Level 2 fields:

- sit bone distance,
- measured seat width,
- planned added height,
- planned removed foam,
- material type,
- highway percentage,
- passenger/luggage use.

This keeps the first tool usable while still making the data model ready for deeper calculations later.

## Data Confidence Rule

Every output should show confidence:

- high: measured bike and seat data plus rider measurements,
- medium: official bike data plus user body data,
- low: category estimates and missing seat measurements.

If confidence is low, the tool should recommend measurements before strong buying or cutting advice.
