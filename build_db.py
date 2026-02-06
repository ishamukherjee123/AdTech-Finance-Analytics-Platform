import sqlite3
import os

# Create database
db_path = '/home/claude/amazon_ads_analytics/amazon_ads.db'
conn = sqlite3.connect(db_path)

# Read and execute SQL file
with open('/home/claude/amazon_ads_analytics/create_database.sql', 'r') as f:
    sql_script = f.read()
    conn.executescript(sql_script)

conn.commit()
conn.close()

print(f"✓ Database created successfully at: {db_path}")
print("✓ Tables created: advertisers, campaigns, campaign_daily_metrics")
print("✓ Sample data inserted for 5 advertisers, 12 campaigns, and daily metrics for January 2025")
