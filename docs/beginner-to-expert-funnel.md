# Beginner To Expert Funnel

Status: concept draft

Purpose: define how Moto Seat Lab should help a complete beginner immediately, then gradually offer deeper levels for riders who want more detail.

The first screen must not feel like an expert form. The user may know only this:

```text
My original seat hurts after about one hour.
I want a more comfortable motorcycle seat.
```

That is enough to start.

## Core Product Principle

Help first. Explain later.

The website should:

- start with the rider's pain and goal,
- offer practical next options quickly,
- avoid asking for expert measurements too early,
- disclose confidence and missing data honestly,
- let the user go deeper step by step,
- compare buying, professional work, and DIY without pretending one path is always best.

## Funnel Levels

### Level 0: Instant Help

Question:

```text
What bothers you most about your current seat?
```

Minimal inputs:

- motorcycle brand/model/year if known,
- original seat or already modified,
- pain starts after about how long,
- main pain/problem,
- main ride type,
- budget feeling,
- preference: buy, professional, DIY, not sure.

No measurements required.

Outputs:

- likely problem category,
- 3 to 5 realistic solution paths,
- quick warning if the user is about to choose a bad path,
- links to matching OEM/aftermarket/professional/add-on/DIY options when available,
- confidence level,
- what to measure only if the user wants better accuracy.

### Level 1: Guided Beginner

Ask only beginner-friendly questions:

- Do you slide forward?
- Does it feel too hard or too soft?
- Is the pain on sit bones, tailbone, inner thighs, knees, back, wrists, or neck?
- Do you ride mostly short rides, day trips, highway touring, city, or bad roads?
- Do you ride alone or with passenger/luggage?
- Are you short, average, or tall for the bike?
- Are you willing to modify the original seat?

Outputs:

- recommended first test,
- recommended buying path,
- products or categories to research,
- "do not buy this yet" warnings,
- next optional questions.

### Level 2: Practical Comparison

For users ready to compare options:

- stock seat baseline,
- OEM comfort/low/high/heated seat,
- aftermarket seats,
- custom upholsterer,
- add-on pads and covers,
- DIY material stack.

Outputs:

- cost range,
- expected comfort potential,
- seat height impact,
- reversibility,
- risk,
- expected fit for ride type,
- source confidence,
- product links and affiliate links where available.

### Level 3: DIY Planner

For users who want to modify or build:

- rider measurements,
- seat measurements,
- material stack,
- foam removal/addition,
- cover and adhesive choices,
- tools,
- test plan.

Outputs:

- layer plan,
- shopping list,
- required tools,
- skill warning,
- test checklist,
- safety notes.

### Level 4: Expert / Lab

For deep data:

- rider triangle geometry,
- suspension sag,
- measured seat profiles,
- foam technical specs,
- pressure/load estimates,
- scenario-specific calculations.

Outputs:

- confidence-banded calculations,
- source trace,
- expert comparison,
- data contribution workflow.

## Honest Recommendation Style

The site should avoid sales language.

Good recommendation:

```text
If you ride long highway days and have budget, a quality model-specific aftermarket or professional rebuild may be the cleanest path. It is expensive, but low effort and usually more predictable than beginner DIY.
```

Good warning:

```text
If you mostly ride short city trips, a large touring seat may be overkill and can reduce movement. Try a reversible add-on or smaller ergonomic change first.
```

Good affiliate disclosure:

```text
Some links may be affiliate links. The recommendation should still show cheaper, non-affiliate, DIY, and professional alternatives when they fit better.
```

Bad recommendation:

```text
Buy this premium seat and your problem is solved.
```

## Buy-First User Path

Some users do not want to build anything.

For them, the site should immediately show:

- OEM options from the motorcycle manufacturer,
- aftermarket options,
- professional upholstery/custom rebuild options,
- reversible add-ons,
- approximate price ranges,
- country availability,
- warranty/return notes,
- fitment confidence,
- link source and affiliate status.

The output should say when an expensive option may not make sense.

Examples:

- A premium touring seat may fit long-distance riders better than short sporty riders.
- A low seat may help reach to ground but can worsen knee angle and reduce foam thickness.
- A soft gel pad may feel good at first but can add heat or instability.
- A custom upholsterer may be better than buying multiple unsuitable products.

## Database Implications

The data model must support both beginner and expert workflows.

Required product-oriented entities:

- `solution_path`
- `seat_product`
- `product_offer`
- `retailer_link`
- `affiliate_link`
- `fitment_claim`
- `recommendation_rule`
- `recommendation_warning`
- `user_intent`

Each purchasable option should store:

- motorcycle compatibility,
- country availability,
- price range,
- seller/retailer,
- source URL,
- affiliate URL if available,
- affiliate disclosure required yes/no,
- return policy notes,
- warranty notes,
- fitment confidence,
- comfort claim source,
- last verified date.

Each recommendation should store:

- who it is for,
- who it is not for,
- expected benefit,
- expected downside,
- cost level,
- effort level,
- reversibility,
- ride type fit,
- confidence,
- evidence/source notes.

## First Version Recommendation

Version 0.1 should start with a simple page:

```text
Original seat hurts after one hour?
Pick your motorcycle and riding style. We will show realistic options:
quick fixes, buy-ready seats, professional rebuild, and DIY.
```

Only after the first answer should the site offer:

- "Improve accuracy"
- "Compare products"
- "Plan a DIY seat"
- "Go expert mode"
