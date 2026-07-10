
# Sales Pipeline & Deal Performance Analytics

An end-to-end analytics project that turns a raw B2B sales pipeline export into a decision-ready Power BI dashboard, a findings report, and an executive presentation — covering the full workflow from data cleaning in R to SQL analysis in PostgreSQL to visualization and storytelling.

---

## Overview

A Vietnamese B2B software company wanted to understand its FY2024 sales performance: **how it performed, why deals were won or lost, and what the pipeline outlook looked like.**

This project answers those questions through a Descriptive → Diagnostic → Predictive analysis, delivered as a three-page interactive dashboard supported by a written report and a slide deck. The emphasis is on turning raw pipeline data into clear, defensible business insight — not just charts.

---

## Dataset

- **Records:** 500 deals (505 raw, cleaned to 500)
- **Fields:** 42 columns — deal metadata, financials, pipeline stage, sales rep, region, and post-sale satisfaction
- **Period:** Full 2024 fiscal year
- **Currency:** VND
- **Context:** B2B software/tech sales to Vietnamese enterprises

Key feature groups: deal financials (contract value, discount, net revenue, cost, gross profit), pipeline data (stage, win probability, forecast category), and engagement signals (activities, CSAT, NPS).

---

## Tools

| Stage | Tool |
|-------|------|
| Exploration & cleaning | R (RStudio, tidyverse) |
| Data storage & querying | PostgreSQL (SQL) |
| Dashboard & measures | Power BI (DAX) |
| Report | Markdown |
| Presentation | Gamma |

---

## Steps

1. **Load & explore (R / RStudio)** — imported the raw dataset and ran exploratory data analysis to understand distributions, spot inconsistencies, and profile missing values.
2. **Clean (R)** — removed duplicate records, standardised categorical labels (regions, pipeline stages), corrected invalid entries such as negative discounts, and handled missing values to produce an analysis-ready table.
3. **Query (PostgreSQL)** — loaded the cleaned data into PostgreSQL and wrote aggregation queries answering the core business questions (win rate by region/rep, revenue by product, discount vs win rate, pipeline funnel, weighted vs open pipeline).
4. **Visualise (Power BI)** — connected the query-ready data to Power BI and built a three-page dashboard, with key metrics implemented as DAX measures.
5. **Report** — summarised the findings and recommendations in a concise written report.
6. **Present (Gamma)** — packaged the story into an executive slide deck for stakeholders.

---

## Dashboard

A three-page Power BI report, one page per analytical stage:

- **Overview (Descriptive)** — headline KPIs, revenue by product and region, win rate trend, and the pipeline funnel. *What happened.*
- **Loss Analysis (Diagnostic)** — loss reasons, discount effectiveness, margin leakage, and rep performance. *Why we win or lose.*
- **Predictive Analysis** — open vs weighted pipeline, forecast, and pipeline concentration by region and tier. *What's next.*

Interactive slicers (Region, Quarter, Deal size) let users filter every visual on demand.

---

## Results

Key findings from the analysis:

- **80.9 tỷ** won revenue at a **53% win rate** and **65% gross margin** in FY2024.
- **Discounting doesn't buy wins** — the 15–20% discount band won just **47%**, *below* the 0–5% band, while leaking **10.57 tỷ** in margin.
- **Losses are driven by fit, not price** — internal decision changes and requirement mismatches dominated; only **5 deals** were lost to price.
- **Pipeline is thinner than it looks** — **446 tỷ** open pipeline weighted down to **159 tỷ** at a 34% average win probability.
- **Concentration risk** — the pipeline leans heavily on the Enterprise segment, which also has the weakest win rate.

These translated into concrete recommendations: fix qualification rather than pricing, cap discounts near 15%, rebalance toward Mid-Market, and prioritise late-stage pipeline.

---

## How to Run

1. **Download the files** from this repository.
2. **Explore & clean** — open the R script in RStudio and run it to generate the cleaned dataset.
3. **Load to PostgreSQL** — import the cleaned data and run the SQL query script.
4. **Open the dashboard** — open the Power BI (`.pbix`) file in Power BI Desktop.
5. **View the report & deck** — the findings report and presentation are included in the files.

---

*Built as a portfolio project demonstrating the full analytics workflow — data cleaning, SQL analysis, dashboard design, and business storytelling.*
