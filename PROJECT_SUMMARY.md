# PROJECT COMPLETE: Amazon Ads Finance Analytics Platform

## Summary

A **complete, working Business Intelligence platform** for AdTech, it's a professional analytics solution that demonstrates real BI skills.

---

## 📦 Deliverables

### Core Components:
1. **amazon_ads.db** - SQLite database with realistic campaign data
2. **dashboard.html** - Interactive analytics dashboard (OPEN THIS FIRST!)
3. **dashboard_data.json** - Query results powering the dashboard

### SQL & Analytics:
4. **create_database.sql** - Database schema and data generation
5. **analysis_queries.sql** - 10 comprehensive BI queries
6. **build_db.py** - Python script to build database
7. **run_analysis.py** - Execute queries and export results

### Documentation:
8. **README.md** - Complete project overview and technical details
9. **SQL_SHOWCASE.md** - Top 5 queries with explanations
10. **quick_start.sh** - One-command setup script

---

##  Quick Start (5 Minutes)

### Option 1: Just View the Dashboard
1. **Open `dashboard.html` in your browser** - it's fully working!
2. Explore the interactive charts and KPIs
3. Review the campaign performance table

### Option 2: Full Setup
```bash
# Make the script executable
chmod +x quick_start.sh

# Run it
./quick_start.sh

# Open the dashboard
open dashboard.html  # macOS
xdg-open dashboard.html  # Linux
start dashboard.html  # Windows
```

---


##  What This Project Demonstrates

### Technical Skills:
✅ **SQL Mastery** - Complex joins, CTEs, window functions, calculated metrics  
✅ **Database Design** - Normalized schema, proper foreign keys  
✅ **Data Visualization** - Interactive charts with meaningful insights  
✅ **Python** - Data processing and automation  
✅ **Web Development** - Professional dashboard UI  

### Business Skills:
✅ **Financial Acumen** - Understanding of ROAS, budget pacing, ROI  
✅ **Advertising Metrics** - CTR, CPC, conversion rates  
✅ **Strategic Thinking** - Budget reallocation recommendations  
✅ **Communication** - Clear, actionable insights  

### BI Skills:
✅ **End-to-End Pipeline** - Data modeling → Analysis → Visualization  
✅ **Actionable Insights** - Not just reports, but recommendations  
✅ **Scalable Architecture** - Could handle millions of rows  
✅ **User-Centric Design** - Dashboard built for finance decision-makers  

---

##  Dashboard Features

### KPI Cards (6):
- Total Revenue: $170K+
- Total Spend: $115K+
- Overall ROAS: ~1.5x
- Total Profit: $55K+
- Total Conversions: 800+
- Active Campaigns: 12

### Interactive Charts (5):
1. **Daily Performance Trends** - Revenue, Spend, ROAS over 31 days
2. **Campaign Type Performance** - Bar chart comparing Products, Brands, Display
3. **Industry Performance** - Doughnut chart showing ROAS by vertical
4. **Budget Utilization** - Progress bars showing pacing status
5. **Weekly Trends** - Week-over-week ROAS comparison

### Performance Table:
- Top 10 campaigns ranked by ROAS
- Color-coded performance badges
- Key metrics at a glance

---

##  Business Insights You Can Share

From the January 2025 data:

1. **Budget Optimization Opportunity**
   - Kitchen Essentials campaign has 1.75 ROAS → increase budget by 50%
   - Smart Watches campaign has 0.96 ROAS → reduce budget or optimize
   - Estimated revenue impact: +$15K/month

2. **Channel Strategy**
   - Sponsored Products outperforming Display by 30% on ROAS
   - Recommendation: Shift 20% of Display budget to Products

3. **Pacing Issues**
   - HomeStyle Living on track to hit 100% budget utilization
   - TechGear Pro only at 46% utilization → risk of leaving money on table
   - Recommendation: Increase TechGear Pro daily budgets

4. **Industry Performance**
   - Home & Kitchen leading with highest profit margins
   - Health & Wellness showing strong conversion rates
   - Opportunity: Expand in high-performing verticals

---

## 🔧 Technical Architecture

```
Data Flow:
1. SQLite Database (amazon_ads.db)
   ↓
2. Python Analytics (run_analysis.py)
   ↓
3. JSON Export (dashboard_data.json)
   ↓
4. Web Dashboard (dashboard.html)
   ↓
5. Business Insights
```

### Database Schema:
```
advertisers (5 rows)
  ├─ advertiser_id (PK)
  ├─ advertiser_name
  ├─ industry
  ├─ monthly_budget
  └─ account_manager

campaigns (12 rows)
  ├─ campaign_id (PK)
  ├─ advertiser_id (FK)
  ├─ campaign_name
  ├─ campaign_type
  └─ daily_budget

campaign_daily_metrics (300+ rows)
  ├─ metric_id (PK)
  ├─ campaign_id (FK)
  ├─ date
  ├─ impressions
  ├─ clicks
  ├─ spend
  ├─ conversions
  └─ revenue
```


---

