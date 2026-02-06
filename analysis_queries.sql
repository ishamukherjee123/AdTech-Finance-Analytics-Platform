-- =====================================================
-- AMAZON ADS FINANCE - SQL ANALYSIS QUERIES
-- Business Intelligence Analytics for Campaign Performance
-- =====================================================

-- =====================================================
-- QUERY 1: Campaign Performance Overview with Key Metrics
-- Purpose: Calculate ROAS, CTR, CPC, Conversion Rate for all campaigns
-- Business Value: Identify top and bottom performers
-- =====================================================

SELECT 
    c.campaign_id,
    c.campaign_name,
    c.campaign_type,
    a.advertiser_name,
    a.industry,
    -- Aggregated Metrics
    SUM(m.impressions) AS total_impressions,
    SUM(m.clicks) AS total_clicks,
    SUM(m.spend) AS total_spend,
    SUM(m.conversions) AS total_conversions,
    SUM(m.revenue) AS total_revenue,
    -- Calculated KPIs
    ROUND(SUM(m.revenue) / NULLIF(SUM(m.spend), 0), 2) AS roas,
    ROUND((SUM(m.clicks) * 100.0) / NULLIF(SUM(m.impressions), 0), 2) AS ctr_percent,
    ROUND(SUM(m.spend) / NULLIF(SUM(m.clicks), 0), 2) AS cpc,
    ROUND((SUM(m.conversions) * 100.0) / NULLIF(SUM(m.clicks), 0), 2) AS conversion_rate_percent,
    ROUND(SUM(m.revenue) - SUM(m.spend), 2) AS profit,
    ROUND((SUM(m.revenue) - SUM(m.spend)) / NULLIF(SUM(m.spend), 0) * 100, 2) AS roi_percent
FROM campaigns c
JOIN advertisers a ON c.advertiser_id = a.advertiser_id
JOIN campaign_daily_metrics m ON c.campaign_id = m.campaign_id
GROUP BY c.campaign_id, c.campaign_name, c.campaign_type, a.advertiser_name, a.industry
ORDER BY roas DESC;


-- =====================================================
-- QUERY 2: Daily Trend Analysis
-- Purpose: Track performance trends over time
-- Business Value: Identify seasonality and optimization opportunities
-- =====================================================

SELECT 
    date,
    SUM(impressions) AS daily_impressions,
    SUM(clicks) AS daily_clicks,
    SUM(spend) AS daily_spend,
    SUM(conversions) AS daily_conversions,
    SUM(revenue) AS daily_revenue,
    ROUND(SUM(revenue) / NULLIF(SUM(spend), 0), 2) AS daily_roas,
    ROUND((SUM(clicks) * 100.0) / NULLIF(SUM(impressions), 0), 2) AS daily_ctr
FROM campaign_daily_metrics
GROUP BY date
ORDER BY date;


-- =====================================================
-- QUERY 3: Budget Utilization & Pacing Analysis
-- Purpose: Monitor budget spend vs. allocation
-- Business Value: Prevent overspend and identify underutilized budgets
-- =====================================================

SELECT 
    a.advertiser_name,
    a.monthly_budget,
    SUM(m.spend) AS actual_spend_mtd,
    ROUND((SUM(m.spend) / a.monthly_budget) * 100, 2) AS budget_utilization_percent,
    ROUND(a.monthly_budget - SUM(m.spend), 2) AS remaining_budget,
    COUNT(DISTINCT c.campaign_id) AS active_campaigns,
    ROUND(AVG(m.spend), 2) AS avg_daily_spend,
    -- Projected monthly spend based on current pace
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


-- =====================================================
-- QUERY 4: Campaign Type Performance Comparison
-- Purpose: Compare Sponsored Products vs Brands vs Display
-- Business Value: Guide budget allocation strategy
-- =====================================================

SELECT 
    campaign_type,
    COUNT(DISTINCT c.campaign_id) AS num_campaigns,
    SUM(m.spend) AS total_spend,
    SUM(m.revenue) AS total_revenue,
    ROUND(SUM(m.revenue) / NULLIF(SUM(m.spend), 0), 2) AS avg_roas,
    ROUND(SUM(m.spend) / NULLIF(SUM(m.clicks), 0), 2) AS avg_cpc,
    ROUND((SUM(m.clicks) * 100.0) / NULLIF(SUM(m.impressions), 0), 2) AS avg_ctr,
    ROUND(SUM(m.conversions) * 100.0 / NULLIF(SUM(m.clicks), 0), 2) AS avg_conversion_rate,
    ROUND((SUM(m.revenue) - SUM(m.spend)) / NULLIF(SUM(m.spend), 0) * 100, 2) AS roi_percent
FROM campaigns c
JOIN campaign_daily_metrics m ON c.campaign_id = m.campaign_id
GROUP BY campaign_type
ORDER BY avg_roas DESC;


-- =====================================================
-- QUERY 5: Top 5 and Bottom 5 Campaigns by ROAS
-- Purpose: Identify best and worst performers
-- Business Value: Optimize budget allocation - increase spend on winners, fix or pause losers
-- =====================================================

-- Top 5 Performers
SELECT 
    'Top Performer' AS category,
    c.campaign_name,
    a.advertiser_name,
    SUM(m.spend) AS total_spend,
    SUM(m.revenue) AS total_revenue,
    ROUND(SUM(m.revenue) / NULLIF(SUM(m.spend), 0), 2) AS roas,
    SUM(m.conversions) AS conversions
FROM campaigns c
JOIN advertisers a ON c.advertiser_id = a.advertiser_id
JOIN campaign_daily_metrics m ON c.campaign_id = m.campaign_id
GROUP BY c.campaign_id, c.campaign_name, a.advertiser_name
ORDER BY roas DESC
LIMIT 5;

-- Bottom 5 Performers
SELECT 
    'Bottom Performer' AS category,
    c.campaign_name,
    a.advertiser_name,
    SUM(m.spend) AS total_spend,
    SUM(m.revenue) AS total_revenue,
    ROUND(SUM(m.revenue) / NULLIF(SUM(m.spend), 0), 2) AS roas,
    SUM(m.conversions) AS conversions
FROM campaigns c
JOIN advertisers a ON c.advertiser_id = a.advertiser_id
JOIN campaign_daily_metrics m ON c.campaign_id = m.campaign_id
GROUP BY c.campaign_id, c.campaign_name, a.advertiser_name
ORDER BY roas ASC
LIMIT 5;


-- =====================================================
-- QUERY 6: Industry Performance Analysis
-- Purpose: Compare performance across different industries
-- Business Value: Identify high-value verticals for business development
-- =====================================================

SELECT 
    a.industry,
    COUNT(DISTINCT a.advertiser_id) AS num_advertisers,
    COUNT(DISTINCT c.campaign_id) AS num_campaigns,
    SUM(m.spend) AS total_spend,
    SUM(m.revenue) AS total_revenue,
    ROUND(SUM(m.revenue) / NULLIF(SUM(m.spend), 0), 2) AS avg_roas,
    ROUND((SUM(m.revenue) - SUM(m.spend)), 2) AS total_profit,
    ROUND(SUM(m.spend) / COUNT(DISTINCT a.advertiser_id), 2) AS avg_spend_per_advertiser
FROM advertisers a
JOIN campaigns c ON a.advertiser_id = c.advertiser_id
JOIN campaign_daily_metrics m ON c.campaign_id = m.campaign_id
GROUP BY a.industry
ORDER BY total_profit DESC;


-- =====================================================
-- QUERY 7: Week-over-Week Performance Comparison
-- Purpose: Identify weekly trends and changes
-- Business Value: Quick insight into momentum and campaign health
-- =====================================================

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
    weekly_conversions,
    weekly_roas,
    ROUND(weekly_revenue - weekly_spend, 2) AS weekly_profit
FROM weekly_metrics
ORDER BY 
    CASE week_period
        WHEN 'Week 1' THEN 1
        WHEN 'Week 2' THEN 2
        WHEN 'Week 3' THEN 3
        ELSE 4
    END;


-- =====================================================
-- QUERY 8: Conversion Funnel Analysis
-- Purpose: Analyze the path from impression to conversion
-- Business Value: Identify bottlenecks in the conversion funnel
-- =====================================================

SELECT 
    c.campaign_name,
    c.campaign_type,
    SUM(m.impressions) AS impressions,
    SUM(m.clicks) AS clicks,
    SUM(m.conversions) AS conversions,
    -- Funnel metrics
    ROUND((SUM(m.clicks) * 100.0) / NULLIF(SUM(m.impressions), 0), 2) AS impression_to_click_rate,
    ROUND((SUM(m.conversions) * 100.0) / NULLIF(SUM(m.clicks), 0), 2) AS click_to_conversion_rate,
    ROUND((SUM(m.conversions) * 100.0) / NULLIF(SUM(m.impressions), 0), 4) AS impression_to_conversion_rate,
    -- Revenue metrics
    ROUND(SUM(m.revenue) / NULLIF(SUM(m.conversions), 0), 2) AS avg_order_value,
    ROUND(SUM(m.spend) / NULLIF(SUM(m.conversions), 0), 2) AS cost_per_conversion
FROM campaigns c
JOIN campaign_daily_metrics m ON c.campaign_id = m.campaign_id
GROUP BY c.campaign_id, c.campaign_name, c.campaign_type
HAVING SUM(m.conversions) > 0
ORDER BY conversions DESC;


-- =====================================================
-- QUERY 9: Account Manager Portfolio Performance
-- Purpose: Evaluate performance by account manager
-- Business Value: Identify top performers and areas needing support
-- =====================================================

SELECT 
    a.account_manager,
    COUNT(DISTINCT a.advertiser_id) AS num_accounts,
    SUM(ad.monthly_budget) AS total_managed_budget,
    COUNT(DISTINCT c.campaign_id) AS num_campaigns,
    SUM(m.spend) AS total_spend,
    SUM(m.revenue) AS total_revenue,
    ROUND(SUM(m.revenue) / NULLIF(SUM(m.spend), 0), 2) AS portfolio_roas,
    ROUND((SUM(m.revenue) - SUM(m.spend)), 2) AS total_profit,
    ROUND(SUM(m.revenue) / COUNT(DISTINCT a.advertiser_id), 2) AS avg_revenue_per_account
FROM advertisers a
LEFT JOIN advertisers ad ON a.advertiser_id = ad.advertiser_id
LEFT JOIN campaigns c ON a.advertiser_id = c.advertiser_id
LEFT JOIN campaign_daily_metrics m ON c.campaign_id = m.campaign_id
GROUP BY a.account_manager
ORDER BY total_profit DESC;


-- =====================================================
-- QUERY 10: Budget Reallocation Recommendations
-- Purpose: Identify opportunities to shift budget from low to high performers
-- Business Value: Maximize overall ROAS through optimization
-- =====================================================

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
    daily_budget,
    ROUND(avg_daily_spend, 2) AS current_avg_daily_spend,
    roas,
    recommendation,
    CASE 
        WHEN recommendation = 'Increase Budget' THEN ROUND(daily_budget * 1.5, 2)
        WHEN recommendation = 'Reduce Budget' THEN ROUND(daily_budget * 0.5, 2)
        ELSE daily_budget
    END AS recommended_daily_budget,
    CASE 
        WHEN recommendation = 'Increase Budget' THEN ROUND((daily_budget * 1.5) - daily_budget, 2)
        WHEN recommendation = 'Reduce Budget' THEN ROUND(daily_budget - (daily_budget * 0.5), 2)
        ELSE 0
    END AS budget_change_amount
FROM campaign_performance
ORDER BY roas DESC;

-- =====================================================
-- END OF ANALYSIS QUERIES
-- =====================================================
