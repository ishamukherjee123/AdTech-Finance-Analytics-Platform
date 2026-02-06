# SQL Query Showcase
## Top 5 Most Impressive Queries for Interview Discussion

---

## Query 1: Campaign Performance with Calculated KPIs
### Business Question: "Which campaigns are most profitable?"

```sql
SELECT 
    c.campaign_name,
    a.advertiser_name,
    c.campaign_type,
    -- Raw Metrics
    SUM(m.spend) AS total_spend,
    SUM(m.revenue) AS total_revenue,
    SUM(m.conversions) AS total_conversions,
    -- Calculated KPIs
    ROUND(SUM(m.revenue) / NULLIF(SUM(m.spend), 0), 2) AS roas,
    ROUND((SUM(m.clicks) * 100.0) / NULLIF(SUM(m.impressions), 0), 2) AS ctr_percent,
    ROUND(SUM(m.spend) / NULLIF(SUM(m.clicks), 0), 2) AS cpc,
    ROUND((SUM(m.conversions) * 100.0) / NULLIF(SUM(m.clicks), 0), 2) AS conversion_rate,
    ROUND(SUM(m.revenue) - SUM(m.spend), 2) AS profit
FROM campaigns c
JOIN advertisers a ON c.advertiser_id = a.advertiser_id
JOIN campaign_daily_metrics m ON c.campaign_id = m.campaign_id
GROUP BY c.campaign_id, c.campaign_name, a.advertiser_name, c.campaign_type
ORDER BY roas DESC;
```

**Key Techniques:**
- Multiple table JOINs
- Aggregate functions (SUM)
- NULLIF for division by zero protection
- ROUND for financial precision
- Calculated metrics (ROAS, CTR, CPC)

**Business Impact:**
Identifies top-performing campaigns for budget increases and bottom performers for optimization or pause.

---

## Query 2: Budget Pacing & Forecast Analysis
### Business Question: "Are we on track to spend our monthly budget?"

```sql
SELECT 
    a.advertiser_name,
    a.monthly_budget,
    SUM(m.spend) AS actual_spend_mtd,
    ROUND((SUM(m.spend) / a.monthly_budget) * 100, 2) AS budget_utilization_percent,
    ROUND(a.monthly_budget - SUM(m.spend), 2) AS remaining_budget,
    -- Forecasting
    ROUND(AVG(m.spend) * 31, 2) AS projected_monthly_spend,
    CASE 
        WHEN (AVG(m.spend) * 31) > a.monthly_budget THEN 'Over Pace'
        WHEN (AVG(m.spend) * 31) < (a.monthly_budget * 0.8) THEN 'Under Pace'
        ELSE 'On Pace'
    END AS pacing_status
FROM advertisers a
JOIN campaigns c ON a.advertiser_id = c.advertiser_id
JOIN campaign_daily_metrics m ON c.campaign_id = m.campaign_id
WHERE c.status = 'Active'
GROUP BY a.advertiser_id, a.advertiser_name, a.monthly_budget
ORDER BY budget_utilization_percent DESC;
```

**Key Techniques:**
- Forecasting using AVG and projection (AVG * 31 days)
- CASE statement for business rules
- Percentage calculations
- WHERE clause for filtering active campaigns

**Business Impact:**
Prevents budget overruns and identifies under-utilized budgets that could be reallocated for more revenue.

---

## Query 3: Budget Reallocation Recommendations
### Business Question: "Which campaigns should get more/less budget?"

```sql
WITH campaign_performance AS (
    SELECT 
        c.campaign_id,
        c.campaign_name,
        c.daily_budget,
        SUM(m.spend) / 31.0 AS avg_daily_spend,
        ROUND(SUM(m.revenue) / NULLIF(SUM(m.spend), 0), 2) AS roas,
        CASE 
            WHEN ROUND(SUM(m.revenue) / NULLIF(SUM(m.spend), 0), 2) >= 1.8 THEN 'Increase Budget'
            WHEN ROUND(SUM(m.revenue) / NULLIF(SUM(m.spend), 0), 2) BETWEEN 1.2 AND 1.79 THEN 'Maintain'
            ELSE 'Reduce Budget'
        END AS recommendation
    FROM campaigns c
    JOIN campaign_daily_metrics m ON c.campaign_id = m.campaign_id
    GROUP BY c.campaign_id, c.campaign_name, c.daily_budget
)
SELECT 
    campaign_name,
    daily_budget AS current_budget,
    roas,
    recommendation,
    CASE 
        WHEN recommendation = 'Increase Budget' THEN ROUND(daily_budget * 1.5, 2)
        WHEN recommendation = 'Reduce Budget' THEN ROUND(daily_budget * 0.5, 2)
        ELSE daily_budget
    END AS recommended_budget,
    CASE 
        WHEN recommendation = 'Increase Budget' THEN ROUND((daily_budget * 1.5) - daily_budget, 2)
        WHEN recommendation = 'Reduce Budget' THEN ROUND(daily_budget - (daily_budget * 0.5), 2)
        ELSE 0
    END AS budget_change
FROM campaign_performance
ORDER BY roas DESC;
```

**Key Techniques:**
- Common Table Expression (CTE)
- Nested CASE statements
- Business logic encoding (ROAS thresholds)
- Budget calculation (+50% for winners, -50% for losers)

**Business Impact:**
Provides actionable recommendations to maximize portfolio ROAS by shifting budget from low to high performers.

---

## Query 4: Week-over-Week Performance Trends
### Business Question: "How is performance changing over time?"

```sql
WITH weekly_metrics AS (
    SELECT 
        CASE 
            WHEN CAST(STRFTIME('%d', date) AS INTEGER) BETWEEN 1 AND 7 THEN 'Week 1'
            WHEN CAST(STRFTIME('%d', date) AS INTEGER) BETWEEN 8 AND 14 THEN 'Week 2'
            WHEN CAST(STRFTIME('%d', date) AS INTEGER) BETWEEN 15 AND 21 THEN 'Week 3'
            ELSE 'Week 4+'
        END AS week_period,
        SUM(spend) AS weekly_spend,
        SUM(revenue) AS weekly_revenue,
        SUM(conversions) AS weekly_conversions,
        ROUND(SUM(revenue) / NULLIF(SUM(spend), 0), 2) AS weekly_roas
    FROM campaign_daily_metrics
    GROUP BY week_period
)
SELECT 
    week_period,
    weekly_spend,
    weekly_revenue,
    weekly_roas,
    ROUND(weekly_revenue - weekly_spend, 2) AS weekly_profit,
    -- Compare to previous week (requires LAG function in production)
    ROUND(((weekly_roas - LAG(weekly_roas, 1) OVER (ORDER BY week_period)) / 
           NULLIF(LAG(weekly_roas, 1) OVER (ORDER BY week_period), 0)) * 100, 2) AS roas_change_percent
FROM weekly_metrics
ORDER BY 
    CASE week_period
        WHEN 'Week 1' THEN 1
        WHEN 'Week 2' THEN 2
        WHEN 'Week 3' THEN 3
        ELSE 4
    END;
```

**Key Techniques:**
- CTE for intermediate calculations
- STRFTIME for date manipulation
- Custom ordering with CASE
- Window function (LAG) for trend analysis
- Week-over-week comparison

**Business Impact:**
Identifies momentum changes - growing or declining performance - to trigger proactive optimizations.

---

## Query 5: Conversion Funnel Analysis
### Business Question: "Where are we losing customers in the funnel?"

```sql
SELECT 
    c.campaign_name,
    c.campaign_type,
    -- Funnel Stages
    SUM(m.impressions) AS impressions,
    SUM(m.clicks) AS clicks,
    SUM(m.conversions) AS conversions,
    -- Funnel Conversion Rates
    ROUND((SUM(m.clicks) * 100.0) / NULLIF(SUM(m.impressions), 0), 2) AS impression_to_click_rate,
    ROUND((SUM(m.conversions) * 100.0) / NULLIF(SUM(m.clicks), 0), 2) AS click_to_conversion_rate,
    ROUND((SUM(m.conversions) * 100.0) / NULLIF(SUM(m.impressions), 0), 4) AS end_to_end_rate,
    -- Economic Metrics
    ROUND(SUM(m.revenue) / NULLIF(SUM(m.conversions), 0), 2) AS avg_order_value,
    ROUND(SUM(m.spend) / NULLIF(SUM(m.conversions), 0), 2) AS cost_per_conversion,
    -- Bottleneck Identification
    CASE 
        WHEN ROUND((SUM(m.clicks) * 100.0) / NULLIF(SUM(m.impressions), 0), 2) < 1.0 THEN 'Low CTR - Creative Issue'
        WHEN ROUND((SUM(m.conversions) * 100.0) / NULLIF(SUM(m.clicks), 0), 2) < 5.0 THEN 'Low Conversion - Landing Page Issue'
        ELSE 'Healthy Funnel'
    END AS bottleneck
FROM campaigns c
JOIN campaign_daily_metrics m ON c.campaign_id = m.campaign_id
GROUP BY c.campaign_id, c.campaign_name, c.campaign_type
HAVING SUM(m.conversions) > 0
ORDER BY conversions DESC;
```

**Key Techniques:**
- Multi-stage funnel analysis
- Rate calculations at each stage
- HAVING clause for filtering
- CASE for automated diagnosis
- Economic value per conversion

**Business Impact:**
Pinpoints where campaigns are losing customers (creative vs landing page) to guide optimization efforts.

---


### Why These Queries Stand Out:

1. **Business-Driven**: Every query answers a real Amazon Ads Finance question
2. **Production-Ready**: Proper null handling, rounding, and error prevention
3. **Scalable**: Would work on millions of rows with proper indexing
4. **Actionable**: Outputs drive specific decisions, not just reports

### Technical Depth Demonstrated:

- ✅ Multi-table JOINs
- ✅ Aggregate functions with grouping
- ✅ Window functions (LAG)
- ✅ Common Table Expressions (CTEs)
- ✅ Complex CASE logic
- ✅ Date manipulation
- ✅ Business metric calculations
- ✅ Forecasting and projection
- ✅ Null safety with NULLIF

### Performance Considerations:

** "How would you optimize these for production?"**

1. **Indexes**: Add indexes on:
   - campaign_daily_metrics(campaign_id, date)
   - campaigns(advertiser_id)
   - Foreign key columns

2. **Materialized Views**: Pre-calculate common aggregations
3. **Partitioning**: Partition by date for large historical datasets
4. **Query Hints**: Use EXPLAIN QUERY PLAN to optimize

**Example:**
```sql
CREATE INDEX idx_metrics_campaign_date 
ON campaign_daily_metrics(campaign_id, date);
```

---

## Sample Output Preview

### Query 1 Results:
```
campaign_name              | advertiser_name  | roas | profit    | recommendation
Kitchen Essentials         | HomeStyle Living | 1.75 | $82,450   | Increase Budget
Premium Headphones - Q1    | TechGear Pro     | 1.50 | $34,100   | Maintain
Smart Watches Launch       | TechGear Pro     | 0.96 | -$3,750   | Reduce Budget
```

### Query 2 Results:
```
advertiser_name    | budget_utilization | pacing_status | projected_monthly_spend
HomeStyle Living   | 72.3%             | On Pace       | $198,450
TechGear Pro       | 45.8%             | Under Pace    | $68,700
```

