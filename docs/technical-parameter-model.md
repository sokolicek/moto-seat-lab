# Technical Parameter Model

Status: concept draft

Purpose: define what technical data Moto Seat Lab should collect for motorcycles, seats, riders, materials, and riding scenarios so future tools can estimate seat comfort, rider triangle, seat loading, heat risk, and DIY modification impact.

Important: the calculations are guidance estimates, not medical, safety, or engineering certification.

## 1. What The Model Must Support

Moto Seat Lab should eventually answer questions like:

- Will this seat likely be comfortable for my body and riding style?
- Will a thicker foam, gel pad, mesh pad, or aftermarket seat make seat height risky?
- How does the stock seat compare with OEM comfort, aftermarket, upholsterer, and DIY options?
- Is the problem likely pressure, shape, sliding, heat, vibration, reach, or posture?
- What material stack is realistic for my budget and skill level?
- What should I measure before cutting foam or buying parts?

The data model should therefore separate:

- motorcycle geometry,
- stock seat geometry,
- optional seat geometry,
- rider body data,
- riding scenario,
- material properties,
- confidence/source metadata,
- calculation rule versions.

## 2. Motorcycle Parameters

### Identity And Fitment

- manufacturer
- model
- generation
- model years
- market or country version
- trim/package
- VIN range if relevant later
- engine displacement
- motorcycle category
- intended use category
- source URL
- source type
- confidence level

Suggested motorcycle categories:

- sport touring
- adventure touring
- naked
- sport
- cruiser
- touring
- city/commuter
- scooter
- maxi-scooter
- dual sport
- enduro/off-road
- classic/retro

### Mass And Load

- wet weight kg
- dry weight kg if only dry is available
- maximum permitted weight kg
- payload capacity kg
- front axle load kg
- rear axle load kg
- wheelbase mm
- center of gravity estimate if known
- luggage capacity kg
- passenger allowed yes/no
- typical top case use yes/no
- pannier use yes/no
- fuel tank capacity l

Why it matters:

- heavier bikes can change suspension sag and seat height under load,
- luggage and passenger weight change the rider posture and rear suspension compression,
- rear-heavy bikes can feel different under braking and acceleration.

### Suspension And Sag

- front suspension travel mm
- rear suspension travel mm
- preload adjustment type
- damping adjustment type
- electronic suspension yes/no
- stock rider sag estimate mm
- user measured rider sag mm
- two-up sag mm
- low suspension option yes/no
- lowering kit present yes/no

Why it matters:

- effective seat height while riding is not the same as brochure seat height,
- sag changes reach to ground, knee angle, hip angle, and load transfer.

### Rider Triangle Geometry

Use one coordinate system per motorcycle, preferably millimeters.
Recommended origin: ground contact midpoint between wheel axles or rear axle center.

Required points:

- seat reference point x/y/z
- lowest seat point x/y/z
- rider seat pocket center x/y/z
- handlebar grip center left/right x/y/z
- footpeg center left/right x/y/z
- brake pedal position x/y/z
- shift lever position x/y/z
- passenger peg position x/y/z

Derived outputs:

- hip-to-knee distance
- knee angle estimate
- hip angle estimate
- forward lean estimate
- footpeg vertical drop from seat
- footpeg rearward offset from seat
- handlebar reach from seat
- handlebar rise/drop from seat

Why it matters:

- seat comfort is strongly affected by posture,
- low/high/rearset footpegs change how much body weight is carried by the seat,
- forward lean can reduce seat load but increase wrist/neck load,
- upright posture can increase seat load during highway riding.

### Seat Mounting And Constraints

- seat pan type
- one-piece or two-piece seat
- rider/passenger split
- seat lock location
- under-seat clearance mm
- available foam removal depth mm
- available foam addition height mm
- heating wiring path possible yes/no
- waterproof membrane present yes/no
- staple-friendly pan yes/no
- pan material
- pan flex estimate

Why it matters:

- some seats allow easy DIY modification,
- some pans limit how much foam can be removed,
- adding heat or gel may cause waterproofing and fitment issues.

### Aerodynamics And Wind Protection

- windscreen height
- windscreen adjustment range
- fairing type
- rider wind exposure level
- typical highway posture
- cruise control yes/no

Why it matters:

- highway wind pressure can unload or load parts of the body depending on posture and windscreen,
- strong wind can push the rider backward into the seat step,
- relaxed cruise control posture can increase seat load because the rider supports less weight through arms/legs.

### Vibration And Road Input

- engine type
- engine vibration character notes
- seat vibration complaints
- handlebar vibration complaints
- footpeg vibration complaints
- tire type
- typical suspension setting
- road surface category

Why it matters:

- numbness may come from pressure, vibration, posture, heat, or a combination,
- off-road and broken roads need different seat priorities than smooth highway.

## 3. Seat Parameters

### Seat Identity

- seat id
- motorcycle id
- seat type
- seat brand
- seat model/name
- stock/OEM/aftermarket/custom/DIY/add-on
- compatible years
- source URL
- country availability
- price range
- confidence level

### Seat Dimensions

Measure at defined stations so different seats can be compared.

Recommended stations:

- front narrow point
- nose transition
- rider sit-bone zone
- rider widest point
- rear support zone
- passenger zone if present

Fields:

- total length mm
- rider usable length mm
- passenger usable length mm
- width front mm
- width sit-bone zone mm
- width mid mm
- width rear mm
- height over stock mm
- lowest point height mm
- crown height mm
- side drop angle deg
- fore-aft slope deg
- lateral crown radius estimate
- step height to passenger section mm
- pocket depth mm
- pocket position x/y/z
- effective support area cm2

Why it matters:

- wide seats spread pressure but can worsen reach to ground,
- too much crown can create pressure lines,
- too much forward slope can slide the rider into the tank,
- a deep pocket can improve highway comfort but reduce movement in curves/off-road.

### Surface And Cover

- cover material
- texture
- friction level dry
- friction level wet
- seam locations
- seam height risk
- waterproof claim
- breathability
- UV resistance
- heat absorption color risk
- cleaning requirements

Why it matters:

- slippery covers change posture and fatigue,
- seams can create pressure points,
- black covers heat up more in sun,
- waterproofing can conflict with breathability.

### Seat Layer Stack

Each layer should be stored separately:

- layer order
- material id
- thickness mm
- coverage area
- position
- taper yes/no
- glued yes/no
- removable yes/no
- purpose

Example layer purposes:

- structural support
- pressure distribution
- comfort top layer
- vibration isolation
- heat management
- waterproofing
- cover finish
- heating

## 4. Material Parameters

### Foam

For foams, collect:

- material family
- open-cell or closed-cell
- density kg/m3
- IFD/ILD at 25 percent compression
- IFD/ILD at 40 percent compression
- compression set
- rebound/resilience
- tensile strength
- elongation
- tear strength
- fatigue resistance
- operating temperature range
- water absorption
- breathability
- recommended thickness range
- cutting difficulty
- sanding/shaping difficulty
- glue compatibility
- cover compatibility
- approximate price per sheet

Useful foam families:

- polyurethane comfort foam
- high resilience foam
- rebond foam
- EVA foam
- PE foam
- memory foam
- latex foam
- neoprene foam

### Gel

For gel inserts or pads:

- gel type
- thickness mm
- durometer/softness if available
- weight per area
- temperature sensitivity
- heat retention risk
- edge transition risk
- waterproof behavior
- puncture risk
- recommended placement
- minimum cover thickness above gel

### 3D Mesh / Spacer Fabric

- thickness mm
- compression resistance
- airflow rating if available
- water drainage behavior
- anti-slip behavior
- durability
- cleaning method
- height impact

### Covers

- material
- stretch direction
- abrasion resistance
- UV resistance
- water resistance
- breathability
- friction dry/wet
- sewing difficulty
- staple behavior
- heat behavior

### Adhesives And Fasteners

- adhesive type
- compatible materials
- heat resistance
- open time
- cure time
- water resistance
- solvent risk
- repositionable yes/no
- indoor safety notes
- staple size
- staple material
- corrosion resistance

## 5. Rider Parameters

### Body Measurements

- age
- height cm
- weight kg
- inseam cm
- torso length cm
- arm length cm
- thigh length cm
- lower leg length cm
- hip width cm
- sit bone distance mm
- boot sole height mm
- preferred seat height confidence

### Comfort And Pain Profile

- pain starts after minutes
- pain location
- numbness yes/no
- heat discomfort yes/no
- sliding forward yes/no
- pressure on tailbone yes/no
- pressure on inner thighs yes/no
- knee pain yes/no
- hip pain yes/no
- wrist/neck fatigue yes/no
- standing breaks frequency
- past seat solutions tried

### Use Profile

- solo/passenger
- luggage
- city percentage
- country road percentage
- highway percentage
- off-road percentage
- average ride duration
- target ride duration
- climate
- season
- rain use
- riding pants type
- typical speed bands

## 6. Riding Scenario Parameters

The same seat can behave differently in different scenarios.

### Scenario Types

- city stop-and-go
- short country ride
- sporty cornering
- long highway
- touring with luggage
- two-up touring
- bad roads
- gravel/off-road seated
- off-road standing
- hot summer
- cold weather with heating

### Scenario Inputs

- average speed km/h
- speed range km/h
- ride duration min
- stop frequency
- acceleration/braking intensity
- cornering intensity
- seated percentage
- standing percentage
- wind exposure
- road roughness
- clothing thickness
- ambient temperature
- rain/wet use

## 7. Seat Load Estimation

Seat load should be treated as an estimate with confidence bands.

### Static Seat Load

Inputs:

- rider weight
- passenger weight
- luggage weight
- posture category
- handlebar reach
- footpeg position
- seat slope
- suspension sag

Outputs:

- estimated seat load kg
- estimated hand load category
- estimated footpeg load category
- confidence level

Simplified concept:

```text
static_seat_load = rider_weight * posture_seat_load_factor
```

The posture factor should be configurable and conservative.

Example posture factor ranges for early prototypes:

- cruiser/upright relaxed: high seat load
- touring/upright: high seat load
- standard/naked: medium to high seat load
- sport touring: medium seat load
- sport forward lean: lower seat load but higher wrist/neck load
- off-road standing: low seated load while standing, high impact when seated

Do not present early numbers as precise measurements.

### Dynamic Load By Scenario

Dynamic effects to model later:

- acceleration shifts rider backward,
- braking shifts rider forward and can increase tank/inner-thigh pressure,
- highway wind can push the rider backward or reduce torso support depending on windscreen,
- cornering changes contact area and rider movement,
- rough roads create impact peaks,
- off-road seated riding creates repeated compression events,
- passenger and luggage increase rear sag and can change seat slope.

Recommended outputs:

- highway comfort load score
- cornering movement freedom score
- braking slide risk
- off-road impact risk
- two-up pressure risk
- heat accumulation risk

## 8. Calculation Outputs

### Geometry Outputs

- estimated new seat height
- reach-to-ground risk
- effective width penalty
- knee angle risk
- hip angle risk
- forward lean estimate
- footpeg load tendency

### Comfort Outputs

- pressure risk
- sit-bone support match
- tailbone pressure risk
- inner-thigh pressure risk
- sliding risk
- heat/sweat risk
- vibration/numbness risk
- long-distance suitability
- short-ride suitability
- off-road suitability

### DIY Outputs

- suggested intervention level
- reversible first step yes/no
- material stack suggestion
- cut/remove foam warning
- required skill level
- required tools
- estimated cost
- test checklist

## 9. Data Model Additions

Future database entities should include:

- `motorcycle_geometry`
- `rider_triangle_measurement`
- `seat_dimension_profile`
- `seat_layer`
- `material_specification`
- `rider_anthropometry`
- `riding_scenario`
- `comfort_problem_report`
- `calculation_rule`
- `calculation_result`
- `source_reference`
- `measurement_method`

Every technical measurement should include:

- value
- unit
- method
- source
- measured_by
- measured_at
- confidence
- notes

## 10. Things Easy To Forget

- seat width affects reach to ground as much as height,
- suspension sag changes real seat height,
- boots change reach,
- rider pants change friction and heat,
- seat slope can matter more than softness,
- too-soft foam can increase pressure after it bottoms out,
- gel can retain heat,
- waterproof layers can reduce breathability,
- seams can cause pressure points,
- passenger/luggage changes sag and slope,
- top case can change highway posture and airflow,
- cruise control can increase seated load,
- off-road riders often stand, so seat comfort priorities differ,
- seat pan shape limits DIY changes,
- cover stretch direction affects fit,
- glue heat resistance matters in summer sun,
- black cover material can become very hot,
- lowering a seat can make knee angle worse,
- raising a seat can improve knees but worsen ground reach,
- professional upholstery may be cheaper than multiple failed DIY attempts.

## 11. Minimum Viable Data For First Tool

For the first useful calculator, do not require everything.

Minimum motorcycle data:

- category
- stock seat height
- stock seat width estimate
- wet weight
- footpeg vertical drop from seat
- handlebar reach category
- suspension sag estimate

Minimum rider data:

- height
- weight
- inseam
- sit bone distance if known
- pain start time
- pain location
- target ride duration
- riding scenario

Minimum seat data:

- current seat type
- planned added/removed height
- support width
- material type
- cover/sliding notes

Minimum output:

- reach risk
- pressure risk
- heat risk
- recommended next experiment
- confidence and missing measurements
