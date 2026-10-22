# Product Analytics Sprint

SQL funnel and retention analysis on e-commerce data (BigQuery) and an A/B test analysis in Python. Self-directed learning projects by K. Bhanushree, final-year B.Tech (CSE, AI and ML).

> These are practice projects on public datasets, not work done for an employer. Every number below comes from my own queries and notebooks in this repository.

## Projects

| # | Project | Question | Tools | Status |
| --- | --- | --- | --- | --- |
| 1 | Funnel and retention analysis | Where do shoppers drop off, and do buyers come back? | BigQuery SQL, Looker Studio | [In progress / Done] |
| 2 | A/B test analysis | Does moving a gate in a mobile game change player retention? | Python (pandas, scipy) | [In progress / Done] |

## Project 1: Funnel and Retention Analysis

**Dataset:** `bigquery-public-data.thelook_ecommerce` (public e-commerce dataset in Google BigQuery).

**Questions**
1. What share of visitors who view a product go on to add it to a cart and buy it?
2. How does conversion differ by traffic source?
3. Of the customers who buy in a given month, how many buy again in the following months?

**Method**
- Defined the funnel from the events table: [steps, for example product view → cart → purchase]
- Built monthly cohorts by [first purchase month]
- All queries are in [`sql/`](sql/), each with a comment explaining the question it answers

**Key findings** *(replace with your real results)*
- The largest drop-off is at [step], where [X]% of users leave
- [Traffic source] converts at [X]% versus [Y]% for [other source]
- [X]% of buyers purchase again within [N] months

**Recommendations** *(replace with your own)*
1. [Change], because [evidence from the data]
2. [Change], because [evidence from the data]

**Dashboard:** [link to the public Looker Studio report]

## Project 2: A/B Test Analysis

**Dataset:** Cookie Cats mobile game A/B test (Kaggle). I link to it instead of storing it here: [Kaggle dataset link].

**Question:** players were shown the first gate at level 30 or level 40. Does the gate position affect day-1 and day-7 retention?

**Method**
- Compared retention between groups with [a two-proportion test and a bootstrap confidence interval]
- Checked [a guardrail metric, such as total game rounds played]
- Notebook: [`python/ab_test_analysis.ipynb`](python/ab_test_analysis.ipynb)

**Result** *(replace with your real results)*
- Day-7 retention: [X]% (gate 30) vs [Y]% (gate 40); difference [Z] points, 95% CI [a, b]
- **Recommendation:** [ship / don't ship / run longer], because [reason]
- **Caveats:** [for example, observational window, novelty effects, possible data issues]

## Repository Structure

```
product-analytics-sprint/
├── README.md
├── requirements.txt
├── sql/                  # BigQuery queries, one file per analysis step
├── python/               # notebooks and scripts
├── writeups/             # one-page summaries of each project
└── images/               # screenshots and charts used in this README
```

## How to Run

**SQL (BigQuery)**
1. Open the [BigQuery sandbox](https://console.cloud.google.com/bigquery) with a Google account (no billing details needed).
2. Query the public dataset `bigquery-public-data.thelook_ecommerce`.
3. Run the files in `sql/` in numerical order.

**Python**
1. `pip install -r requirements.txt`
2. Download the Cookie Cats dataset from Kaggle and place it in a local `data/` folder (not committed).
3. Open the notebook in `python/` and run all cells.

## Skills Demonstrated

SQL (joins, CTEs, window functions, date functions) · funnel and cohort analysis · A/B test analysis · Python (pandas, scipy) · dashboarding in Looker Studio · written recommendations

## Limitations

- Public datasets are synthetic or anonymised and may not reflect a real company's behaviour
- [Add the limits of your own analysis, such as assumptions you made]

## About

K. Bhanushree · [LinkedIn](https://linkedin.com/in/[your-handle]) · [Portfolio](https://[your-notion-link]) · [email]
