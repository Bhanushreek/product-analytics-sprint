# Project 2: E-commerce Funnel and Retention Analysis

A SQL analysis of a public e-commerce dataset in Google BigQuery to find where shoppers drop off and whether buyers come back.

> Self-directed practice project using a public synthetic dataset. This is not work done for an employer, and the results do not describe a real company. Status: In progress.

## Questions

1. What share of sessions that view a product go on to add it to a cart and buy it?
2. How does conversion differ by traffic source and browser?
3. Of the customers who buy in a given month, how many buy again in following months?

## Data

`bigquery-public-data.thelook_ecommerce` (tables: `events`, `orders`, `order_items`, `users`). Queried on 27 October 2026. The public dataset can change, so results may differ if rerun.

## Method

- **Funnel:** Per session, flag a product view, cart event, and purchase event, then count sessions that reached each step. This checks that each event occurred, not their order.
- **Segments:** Compare the same funnel by traffic source and browser; also review monthly conversion and cart abandonment by source.
- **Retention:** Group buyers by the month of their first non-cancelled order, then measure activity 1 to 6 months later. Only cohorts old enough to have 6 full months are included.
- **Repeat purchase:** Calculate the share of buyers with two or more non-cancelled orders, by traffic source, and the median days to a second order.
- Queries are in [`sql/question_bank.sql`](sql/question_bank.sql). Each query has a comment stating its question and finding.

## Key findings

- Of **680,424** product-view sessions, **63.3%** also had a cart event and **26.5%** reached purchase. The largest drop was from cart to purchase: **58.1%** of cart sessions did not reach purchase.
- **Facebook and Organic** had the highest overall conversion at **26.6%**; **YouTube** was lowest at **26.4%**, a **0.2 percentage-point** gap.
- Average cohort retention was about **1.5%** in months 1, 3, and 6. Overall repeat purchase was **33.6%**; the median time to a second order was **257 days**.

## Recommendations

1. Test a simpler cart-to-checkout path and measure cart-to-purchase conversion. Evidence: **58.1%** of cart sessions did not reach purchase. Effort: medium.
2. Review the YouTube landing and checkout journey and measure its conversion and cart abandonment. Evidence: YouTube had the lowest conversion (**26.4%**) and highest abandonment (**58.3%**), though differences by source were small. Effort: low.
3. Investigate why buyers do not return and test a relevant reorder reminder. Measure repeat purchase and cohort retention. Evidence: repeat purchase was **33.6%**, while average cohort retention was about **1.5%** at months 1, 3, and 6. Effort: medium.

## Charts

- [Funnel](images/funnel.png)
- [Conversion by traffic source](images/conversion-by-source.png)
- [Retention heatmap](images/retention-heatmap.png)
- [Average retention by month](images/retention-line-chart.png)
- [Repeat rate by source](images/repeat-rate-by-source.png)

## Working spreadsheet

[View the Google Sheets analysis](https://docs.google.com/spreadsheets/d/1Js0A3oNSFp2YjtL2V1q3D3d79DVpnbusiG95FdLchxM/edit?usp=sharing)

## How to run

1. Open the [BigQuery sandbox](https://console.cloud.google.com/bigquery).
2. Check each table’s Schema tab for column names.
3. Run the queries in [`sql/question_bank.sql`](sql/question_bank.sql).

## Limitations

- The dataset is public and synthetic, so behaviour may not match a real business.
- The funnel is session-level and does not enforce event order.
- Buyers are defined from the orders table, excluding cancelled orders.
- Some months may be incomplete, and small differences between segments should be treated as descriptive.
- Retention values are cohort averages and are very low in this dataset.

## Skills demonstrated

SQL (CTEs, window functions, date functions, joins) · funnel and cohort analysis · charts in Google Sheets · written recommendations
