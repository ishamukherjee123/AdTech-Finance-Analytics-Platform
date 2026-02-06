# Amazon Ads Finance Analytics Platform (An example of Amazon is used because it represents active online shopping sites

**A Business Intelligence Project for Amazon Ads Finance Department**

## 📊 Project Overview

This project demonstrates advanced Business Intelligence capabilities through a comprehensive analytics platform for Amazon Advertising campaign performance analysis. Built with SQL, Python, and interactive web visualizations, it showcases the skills essential for a BI role in Amazon Ads Finance.

## 🎯 Business Value

This repo enables AdTech Finance teams to:

- **Monitor Performance**: Real-time tracking of campaign KPIs (ROAS, CTR, CPC, conversions)
- **Optimize Budgets**: Identify underperforming campaigns and reallocate budgets to high-performers
- **Track Pacing**: Monitor budget utilization and prevent overspend
- **Industry Insights**: Compare performance across different advertiser verticals
- **Data-Driven Decisions**: Use SQL analytics to drive strategic recommendations

## 🛠️ Technology Stack

- **Database**: SQLite (relational database)
- **Query Language**: SQL (advanced analytical queries)
- **Data Processing**: Python 3
- **Visualization**: Chart.js (interactive charts)
- **Frontend**: HTML5, CSS3, JavaScript

## 📁 Project Structure

```
amazon_ads_analytics/
├── amazon_ads.db              # SQLite database with campaign data
├── create_database.sql        # Database schema and sample data generation
├── analysis_queries.sql       # 10 comprehensive BI queries
├── build_db.py               # Python script to build database
├── run_analysis.py           # Execute queries and export results
├── dashboard_data.json       # Query results in JSON format
├── dashboard.html            # Interactive analytics dashboard
└── README.md                 # This file
```

## 📈 Key Features

### 1. Database Design
- **3 normalized tables**: advertisers, campaigns, campaign_daily_metrics
- **Realistic data**: 5 advertisers, 12 campaigns, 31 days of metrics
- **Industry variety**: Electronics, Home & Kitchen, Health, Grocery, Apparel

### 2. SQL Analytics (10 Queries)

1. **Campaign Performance Overview** - Complete KPI analysis with ROAS, CTR, CPC
2. **Daily Trend Analysis** - Time-series performance tracking
3. **Budget Utilization & Pacing** - Spend monitoring and forecasting
4. **Campaign Type Comparison** - Sponsored Products vs Brands vs Display
5. **Top/Bottom Performers** - Identify best and worst campaigns
6. **Industry Performance** - Vertical-based analysis
7. **Week-over-Week Trends** - Weekly performance comparison
8. **Conversion Funnel** - Impression → Click → Conversion analysis
9. **Account Manager Portfolio** - Performance by account manager
10. **Budget Reallocation Recommendations** - Data-driven optimization

### 3. Interactive Dashboard

- **6 KPI Cards**: Revenue, Spend, ROAS, Profit, Conversions, Active Campaigns
- **5 Interactive Charts**:
  - Daily performance trends (multi-line chart)
  - Campaign type performance (bar chart)
  - Industry ROAS distribution (doughnut chart)
  - Budget utilization (horizontal bar chart)
  - Weekly ROAS trends (line chart)
- **Campaign Performance Table**: Top 10 campaigns with color-coded metrics
- **Responsive Design**: Works on desktop, tablet, and mobile

## 🚀 How to Use

### Step 1: Build the Database
```bash
python build_db.py
```
This creates `amazon_ads.db` with all sample data.

### Step 2: Run Analytics Queries
```bash
python run_analysis.py
```
This executes all SQL queries and exports results to `dashboard_data.json`.

### Step 3: View the Dashboard
```bash
# Open dashboard.html in a web browser
# On macOS:
open dashboard.html

# On Linux:
xdg-open dashboard.html

# On Windows:
start dashboard.html
```

## 💡 SQL Skills Demonstrated

### Advanced Query Techniques
- **Aggregations**: SUM, COUNT, AVG, ROUND
- **Joins**: INNER JOIN across multiple tables
- **CTEs**: Common Table Expressions for complex calculations
- **Window Functions**: Date-based grouping and trends
- **Conditional Logic**: CASE statements for business rules
- **Null Handling**: NULLIF for division by zero prevention
- **Calculated Metrics**: ROAS, CTR, CPC, Conversion Rate, ROI

### Business Metrics Calculated
```sql
ROAS = Revenue / Spend
CTR = (Clicks / Impressions) * 100
CPC = Spend / Clicks
Conversion Rate = (Conversions / Clicks) * 100
ROI = ((Revenue - Spend) / Spend) * 100
```

## 📊 Sample Insights

Based on the dummy January 2025 data:

1. **Overall ROAS**: ~1.5x (healthy performance)
2. **Top Performer**: Kitchen Essentials campaign (1.75 ROAS)
3. **Budget Utilization**: Most advertisers are on-pace for monthly budget
4. **Campaign Type**: Sponsored Products outperforming Display
5. **Industry Leader**: Home & Kitchen showing highest profit margins

## 🎨 Dashboard Design

The dashboard follows Amazon's design language:
- **Colors**: Amazon Orange (#FF9900) as primary, complementary blues/greens
- **Typography**: Clean, modern fonts (Outfit, JetBrains Mono)
- **Layout**: Card-based design with clear hierarchy
- **Interactivity**: Hover effects, animated charts, responsive grid

## 📝 Key Takeaways :

This project demonstrates:

✅ **SQL Proficiency**: Complex joins, aggregations, and business logic  
✅ **Data Modeling**: Normalized database design  
✅ **Business Acumen**: Understanding of advertising metrics and finance KPIs  
✅ **Visualization Skills**: Creating meaningful, actionable dashboards  
✅ **End-to-End Thinking**: From data modeling to insights delivery  
✅ **Real-World Application**: Solves actual Amazon Ads Finance problems  

## 🔄 Extensibility

This platform can be extended with:
- Attribution modeling (multi-touch attribution)
- Forecasting models (time-series predictions)
- A/B test analysis capabilities
- Real-time data integration via APIs
- Machine learning for budget optimization
- Automated reporting and alerts

## 📧 Questions?

This project was built to demonstrate Business Intelligence capabilities for Ads Tech Finance roles. The SQL queries, data model, and dashboard are designed to showcase real-world analytical thinking and technical execution.

---

**Built with**: SQL | Python | HTML/CSS/JS | Chart.js  
**Focus**: Business Intelligence | Data Analytics | Financial Reporting  
**Purpose**: Ads Tech Finance Interview Portfolio
