# Bike Database Strategy

## Purpose

The bike database should make the site useful for model-specific searches and recommendations.

Each bike page should answer:

- What kind of motorcycle is it?
- What is the typical riding position?
- What seat comfort problems are likely?
- What quick improvements are realistic?
- What DIY modifications are worth considering?
- What product categories should be researched?
- Which geometry and seat measurements are missing?
- Which measurements are needed for calculation confidence?

## Bike Page Template

```text
Model
Generation / years
Country relevance
Riding category
Seat type
Stock seat height
Stock seat width at sit-bone zone
Footpeg position notes
Handlebar reach notes
Suspension/sag notes
Wind protection notes
Rider triangle notes
Common complaints
Short ride advice
Long ride advice
Highway comfort notes
Bad-road/off-road comfort notes
Passenger notes
Ready-made seat options
Add-on pad options
DIY foam options
Cover and upholstery options
Testing checklist
Missing measurements
Research status
```

## Initial Bike

Suzuki GSX-S1000GX

Reason:

- owner motorcycle,
- sport-touring/crossover use case,
- relevant for long rides,
- good first real-world test model.

## Future Bike Selection Criteria

Prioritize models by:

- country popularity,
- search demand,
- rider discomfort reports,
- touring relevance,
- availability of seat products,
- affiliate opportunities,
- owner community size.

## Required Technical Fields For Useful Calculations

Minimum fields:

- stock seat height,
- approximate stock seat width at sit-bone zone,
- wet weight,
- motorcycle category,
- rider triangle notes,
- seat-to-footpeg drop estimate,
- seat-to-handlebar reach estimate,
- suspension sag estimate or assumption,
- wind protection level,
- common use cases.

Recommended fields:

- measured seat width at multiple stations,
- fore-aft seat slope,
- seat pocket position,
- handlebar coordinates,
- footpeg coordinates,
- passenger peg coordinates,
- suspension travel,
- rider sag with typical rider weight,
- passenger/luggage sag,
- stock cover friction notes,
- known seat complaints from owner forums.

## Candidate Categories

- sport touring,
- adventure touring,
- naked bikes,
- cruisers,
- scooters,
- maxi-scooters,
- enduro/off-road,
- commuter bikes.
