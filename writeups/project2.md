# Project 2: Ecommerce Funnel and Repeat Purchase Analysis

## Question
Where do shoppers drop off, and do buyers come back?

## Data and method
- Dataset: BigQuery public `thelook_ecommerce` dataset; results queried on 27 October 2026.
- Funnel: counted sessions containing product, cart, and purchase events. This checks whether events occurred in the session, not their order.
- Retention: grouped buyers by the month of their first non-cancelled order and measured later monthly activity. Repeat purchase uses non-cancelled orders.

## Findings
1. **The largest funnel drop is from cart to purchase.** Of 430,642 cart sessions, 180,424 reached purchase: a 41.9% cart-to-purchase conversion rate, meaning 58.1% did not reach purchase.
2. **Traffic-source conversion is nearly identical.** Facebook and Organic were highest at 26.6%; YouTube was lowest at 26.4%, a 0.2 percentage-point gap.
3. **Repeat purchase is 33.6%.** Of 71,738 buyers, 24,111 placed at least two non-cancelled orders. Average cohort retention was about 1.5% at months 1, 3, and 6; this synthetic dataset shows very low later-month activity.

## Recommendations
- Test a simpler cart-to-checkout path; measure cart-to-purchase conversion. Evidence: 58.1% of cart sessions did not reach purchase. Effort: medium.
- Audit the YouTube traffic landing and checkout journey; measure its conversion and cart abandonment against other sources. Evidence: YouTube had the lowest conversion (26.4%) and highest abandonment (58.3%), though source differences are small. Effort: low.
- Investigate why buyers do not return and test a relevant reorder reminder; measure repeat purchase rate and cohort retention. Evidence: repeat purchase was 33.6%, while average cohort retention was about 1.5% at months 1, 3, and 6. Effort: medium.

## Limitations
- This is a synthetic public dataset, not company data.
- The session-level funnel does not verify event order.
- Buyers and repeat buyers are defined from the orders table; cancelled orders are excluded.
- Recent or partial months can distort trends and cohort comparisons.
- Traffic-source conversion differences are small and descriptive, not proof that a source caused the result.
- Retention averages are cohort-level averages and may include cohorts with no recorded activity in a month.

## Next steps
Validate the funnel and retention definitions with real event and order data, inspect checkout drop-off by device and payment method, and test one checkout improvement with an experiment.
