import sqlite3
import json

# Connect to database
conn = sqlite3.connect('/home/claude/amazon_ads_analytics/amazon_ads.db')
conn.row_factory = sqlite3.Row  # This enables column access by name

def execute_query(query, query_name):
    """Execute a query and return results as a list of dictionaries"""
    cursor = conn.cursor()
    cursor.execute(query)
    columns = [description[0] for description in cursor.description]
    results = []
    for row in cursor.fetchall():
        results.append(dict(zip(columns, row)))
    return results

# Dictionary to store all query results
all_results = {}

# Query 1: Campaign Performance Overview
print("Executing Query 1: Campaign Performance Overview...")
query1 = """
SELECT 
    c.campaign_id,
    c.campaign_name,
    c.campaign_type,
    a.advertiser_name,
    a.industry,
    SUM(m.impressions) AS total_impressions,
    SUM(m.clicks) AS total_clicks,
    SUM(m.spend) AS total_spend,
    SUM(m.conversions) AS total_conversions,
    SUM(m.revenue) AS total_revenue,
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
ORDER BY roas DESC
"""
all_results['campaign_performance'] = execute_query(query1, 'Campaign Performance')

# Query 2: Daily Trends
print("Executing Query 2: Daily Trend Analysis...")
query2 = """
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
ORDER BY date
"""
all_results['daily_trends'] = execute_query(query2, 'Daily Trends')

# Query 3: Budget Utilization
print("Executing Query 3: Budget Utilization Analysis...")
query3 = """
SELECT 
    a.advertiser_name,
    a.monthly_budget,
    SUM(m.spend) AS actual_spend_mtd,
    ROUND((SUM(m.spend) / a.monthly_budget) * 100, 2) AS budget_utilization_percent,
    ROUND(a.monthly_budget - SUM(m.spend), 2) AS remaining_budget,
    COUNT(DISTINCT c.campaign_id) AS active_campaigns,
    ROUND(AVG(m.spend), 2) AS avg_daily_spend,
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
ORDER BY budget_utilization_percent DESC
"""
all_results['budget_utilization'] = execute_query(query3, 'Budget Utilization')

# Query 4: Campaign Type Comparison
print("Executing Query 4: Campaign Type Performance...")
query4 = """
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
ORDER BY avg_roas DESC
"""
all_results['campaign_type_performance'] = execute_query(query4, 'Campaign Type Performance')

# Query 5: Industry Performance
print("Executing Query 5: Industry Performance...")
query5 = """
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
ORDER BY total_profit DESC
"""
all_results['industry_performance'] = execute_query(query5, 'Industry Performance')

# Query 6: Weekly Trends
print("Executing Query 6: Weekly Performance...")
query6 = """
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
    END
"""
all_results['weekly_performance'] = execute_query(query6, 'Weekly Performance')

# Query 7: Top and Bottom Performers
print("Executing Query 7: Top/Bottom Performers...")
query7_top = """
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
LIMIT 5
"""
query7_bottom = """
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
LIMIT 5
"""
all_results['top_performers'] = execute_query(query7_top, 'Top Performers')
all_results['bottom_performers'] = execute_query(query7_bottom, 'Bottom Performers')

# Query 8: Summary Metrics
print("Executing Query 8: Overall Summary...")
query8 = """
SELECT 
    COUNT(DISTINCT a.advertiser_id) AS total_advertisers,
    COUNT(DISTINCT c.campaign_id) AS total_campaigns,
    SUM(m.impressions) AS total_impressions,
    SUM(m.clicks) AS total_clicks,
    SUM(m.spend) AS total_spend,
    SUM(m.conversions) AS total_conversions,
    SUM(m.revenue) AS total_revenue,
    ROUND(SUM(m.revenue) / NULLIF(SUM(m.spend), 0), 2) AS overall_roas,
    ROUND((SUM(m.clicks) * 100.0) / NULLIF(SUM(m.impressions), 0), 2) AS overall_ctr,
    ROUND(SUM(m.spend) / NULLIF(SUM(m.clicks), 0), 2) AS overall_cpc,
    ROUND((SUM(m.revenue) - SUM(m.spend)), 2) AS total_profit
FROM advertisers a
JOIN campaigns c ON a.advertiser_id = c.advertiser_id
JOIN campaign_daily_metrics m ON c.campaign_id = m.campaign_id
"""
all_results['summary_metrics'] = execute_query(query8, 'Summary Metrics')

# Save all results to JSON file
output_file = '/home/claude/amazon_ads_analytics/dashboard_data.json'
with open(output_file, 'w') as f:
    json.dump(all_results, f, indent=2)

print(f"\n✓ All queries executed successfully!")
print(f"✓ Results exported to: {output_file}")
print(f"✓ Total datasets generated: {len(all_results)}")

# Close connection
conn.close()

# Print summary
print("\n" + "="*60)
print("QUERY EXECUTION SUMMARY")
print("="*60)
for key, data in all_results.items():
    print(f"{key}: {len(data)} records")
print("="*60)
