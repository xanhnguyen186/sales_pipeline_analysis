# Sales Pipeline & Deal Performance — Findings Report

**FY2024 · B2B Enterprise Sales (Vietnam) · Values in VND**

---

## 1. Project Overview

This project turns a raw sales-pipeline export from a Vietnamese B2B software company into a decision-ready analytics product. The dataset covers **500 deals across the full 2024 fiscal year**, each row capturing one deal's financials, pipeline stage, owning sales rep, region, and post-sale satisfaction.

The goal was to answer three questions a sales leader actually asks: **how did we perform, why do we win or lose, and what's the outlook?** The output is a three-page Power BI dashboard — Overview, Loss Analysis, and Predictive Analysis — built on top of a SQL-prepared dataset, following a Descriptive → Diagnostic → Predictive analytical arc.

---

## 2. Dataset Summary

- **Rows:** 505 raw → **500** after cleaning
- **Columns:** 42
- **Period:** January–December 2024 (FY2024)
- **Currency:** VND
- **Deal status mix:** 80 Won · 72 Lost · 348 Open
- **Key feature groups:**
  - *Deal metadata* — sales rep, region, industry, customer type, deal-size tier
  - *Financials* — contract value, discount %, net revenue, cost of sale, gross profit
  - *Pipeline* — stage, win probability, forecast category
  - *Engagement* — activity count, CSAT, NPS
- **Missing data:** nulls were concentrated in `Lost_Reason` (only lost deals carry one — expected), follow-up and notes fields, plus a small number in the contract/net-revenue and identifier columns that required handling before analysis.

The financial columns are internally consistent — net revenue never exceeds contract value, and gross profit reconciles to net revenue minus cost of sale across every row — so margin and discount analysis rests on trustworthy figures.

---

## 3. Data Analysis using SQL (PostgreSQL)

The raw export was loaded into a PostgreSQL staging table, cleaned, and then queried to answer each business question before being connected to Power BI.

**Preparation.** The cleaning pass removed duplicate records by deal identity, standardised categorical labels so regions and pipeline stages grouped correctly (unifying inconsistent casing and accents into canonical values), corrected impossible entries such as negative discounts, and handled missing values in the key financial and identifier fields. This produced a single, analysis-ready table of 500 deals.

**Analysis.** With the data clean, a series of aggregation queries answered the core business questions the dashboard is built on: win rate and average deal value by region and by rep; revenue broken down by product and by deal-size tier; the pipeline funnel by stage; the relationship between discount level and win rate; loss reasons ranked by frequency; and the gap between raw open pipeline and probability-weighted pipeline. These grouped results became the foundation for the dashboard's visuals, with the final calculations (win rate, weighted pipeline, discount leakage) implemented as DAX measures in Power BI.

---

## 4. Dashboard — Key Findings

### Page 1 · Overview — *what happened*

**Headline:** 80.9 tỷ won revenue · 53% win rate · 1,138 tr average deal · 102-day sales cycle.

FY2024 was a solid year on paper, but the revenue is **concentrated**. Software dominates the product mix, and **Miền Bắc and Miền Trung generate the bulk of revenue** while the other two regions trail. The most useful signal here is a regional efficiency mismatch: Miền Bắc brings in high revenue but converts at a **low ~45% win rate**, whereas Tây Nguyên and Miền Trung win at **~60%**. In short, the biggest revenue region is also one of the least efficient at closing — it wins large, but not often.

Monthly performance is volatile, which is expected given the modest number of deals closing each month; individual large deals swing the totals.

### Page 2 · Loss Analysis — *why we lose*

**Headline:** 65% gross margin · 72 lost deals · 10.57 tỷ discount leakage · 47% loss rate.

Two findings carry this page, and both are counterintuitive in a useful way.

First, **losses are driven by soft reasons, not price.** The top causes are *internal decision change* (17) and *requirements mismatch* (15); only **5 deals were lost to price**. That points squarely at qualification and discovery — deals are being pursued that were never a good fit or never had a real decision path, not deals lost on cost.

Second, **discounting doesn't buy wins.** The 15–20% discount band wins just **47%** — *lower* than the 0–5% band at 50% — while the sweet spot is 10–15% at **67%**. Heavy discounting leaked **10.57 tỷ** of margin without improving conversion. Discount is a margin problem masquerading as a growth lever.

The rep scatter (win rate vs sales cycle) shows a clear split at the 53% benchmark: a cluster of high-win, shorter-cycle reps sits above the line, and a red cluster below it, often with longer cycles — a coaching signal, not a headcount one.

### Page 3 · Predictive Analysis — *what's next*

**Headline:** 446 tỷ open pipeline · 159 tỷ weighted · 34% average win probability · ~44 tỷ projected Q1–Q2 2025.

The pipeline looks large but is **thinner than the top line suggests.** The 446 tỷ of open pipeline shrinks to **159 tỷ once weighted by win probability**, and the average open-deal probability is only **34%** — most value sits in low-probability early stages. Nominal coverage is generous; realistic coverage is modest.

It's also **concentrated in Enterprise**: Enterprise pipeline runs 76–108 tỷ per region versus 13–17 tỷ for Mid-Market and under 4 tỷ for SMB. That leans the future on the exact segment with the weakest win rate — a concentration risk.

The forecast projects roughly **44 tỷ for Q1–Q2 2025**. This is an illustrative linear trend on a single, noisy fiscal year — directionally useful, not a committed number.

---

## 5. Business Recommendations

1. **Fix qualification, not pricing.** Losses stem from decision changes and requirement mismatches, not cost — tighten early-stage discovery to screen out poor-fit deals before they consume cycle time.

2. **Cap discounts near 15%.** Beyond that threshold, win rate *falls* while margin erodes; the 10.57 tỷ leaked this year bought no additional conversion. Introduce approval gates above the cap.

3. **Rebalance toward Mid-Market.** It converts better and dilutes the Enterprise concentration risk that currently dominates both revenue and pipeline.

4. **Clean the pipeline before trusting coverage.** A 446 → 159 tỷ gap and a 34% average probability mean forecast coverage is softer than the headline implies — prioritise advancing late-stage, higher-probability deals.

5. **Coach the lagging reps.** The dispersion around the 53% benchmark is a process gap, not a talent gap — replicate the fast-cycle winners' playbook rather than hiring.

6. **Investigate Miền Bắc's efficiency.** It generates high revenue at a low win rate — understanding why a high-value region converts poorly is a near-term margin and growth opportunity.

---

*Prepared from the FY2024 sales pipeline dataset and the accompanying three-page Power BI dashboard. Forecast figures are illustrative trend projections based on a single fiscal year of data.*
