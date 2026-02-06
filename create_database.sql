-- =====================================================
-- AMAZON ADS FINANCE ANALYTICS DATABASE
-- =====================================================
-- This database simulates Amazon Advertising campaign data
-- for Business Intelligence analysis and financial planning
-- =====================================================

-- Drop existing tables if they exist
DROP TABLE IF EXISTS campaign_daily_metrics;
DROP TABLE IF EXISTS campaigns;
DROP TABLE IF EXISTS advertisers;

-- =====================================================
-- TABLE: advertisers
-- Stores advertiser account information
-- =====================================================
CREATE TABLE advertisers (
    advertiser_id INTEGER PRIMARY KEY,
    advertiser_name TEXT NOT NULL,
    industry TEXT NOT NULL,
    account_manager TEXT NOT NULL,
    monthly_budget REAL NOT NULL,
    created_date DATE NOT NULL
);

-- =====================================================
-- TABLE: campaigns
-- Stores campaign metadata and settings
-- =====================================================
CREATE TABLE campaigns (
    campaign_id INTEGER PRIMARY KEY,
    advertiser_id INTEGER NOT NULL,
    campaign_name TEXT NOT NULL,
    campaign_type TEXT NOT NULL, -- Sponsored Products, Sponsored Brands, Sponsored Display
    targeting_type TEXT NOT NULL, -- Auto, Manual
    daily_budget REAL NOT NULL,
    start_date DATE NOT NULL,
    status TEXT NOT NULL, -- Active, Paused, Ended
    FOREIGN KEY (advertiser_id) REFERENCES advertisers(advertiser_id)
);

-- =====================================================
-- TABLE: campaign_daily_metrics
-- Stores daily performance metrics for each campaign
-- =====================================================
CREATE TABLE campaign_daily_metrics (
    metric_id INTEGER PRIMARY KEY AUTOINCREMENT,
    campaign_id INTEGER NOT NULL,
    date DATE NOT NULL,
    impressions INTEGER NOT NULL,
    clicks INTEGER NOT NULL,
    spend REAL NOT NULL,
    conversions INTEGER NOT NULL,
    revenue REAL NOT NULL,
    FOREIGN KEY (campaign_id) REFERENCES campaigns(campaign_id)
);

-- =====================================================
-- INSERT SAMPLE DATA
-- =====================================================

-- Insert Advertisers
INSERT INTO advertisers (advertiser_id, advertiser_name, industry, account_manager, monthly_budget, created_date)
VALUES 
    (1, 'TechGear Pro', 'Electronics', 'Sarah Johnson', 150000, '2024-01-15'),
    (2, 'HomeStyle Living', 'Home & Kitchen', 'Michael Chen', 200000, '2024-01-20'),
    (3, 'FitLife Nutrition', 'Health & Wellness', 'Emily Rodriguez', 100000, '2024-02-01'),
    (4, 'GreenLeaf Organics', 'Grocery', 'David Kim', 120000, '2024-02-10'),
    (5, 'StyleHub Fashion', 'Apparel', 'Jessica Martinez', 180000, '2024-03-01');

-- Insert Campaigns
INSERT INTO campaigns (campaign_id, advertiser_id, campaign_name, campaign_type, targeting_type, daily_budget, start_date, status)
VALUES 
    -- TechGear Pro campaigns
    (101, 1, 'Premium Headphones - Q1', 'Sponsored Products', 'Manual', 2500, '2025-01-01', 'Active'),
    (102, 1, 'Smart Watches Launch', 'Sponsored Brands', 'Manual', 3000, '2025-01-01', 'Active'),
    (103, 1, 'Gaming Accessories', 'Sponsored Display', 'Auto', 1500, '2025-01-15', 'Active'),
    
    -- HomeStyle Living campaigns
    (104, 2, 'Kitchen Essentials', 'Sponsored Products', 'Manual', 3500, '2025-01-01', 'Active'),
    (105, 2, 'Home Decor Collection', 'Sponsored Brands', 'Manual', 4000, '2025-01-01', 'Active'),
    (106, 2, 'Furniture Sale', 'Sponsored Display', 'Auto', 2000, '2025-01-10', 'Active'),
    
    -- FitLife Nutrition campaigns
    (107, 3, 'Protein Powder Range', 'Sponsored Products', 'Manual', 2000, '2025-01-01', 'Active'),
    (108, 3, 'Vitamins & Supplements', 'Sponsored Brands', 'Auto', 1800, '2025-01-05', 'Active'),
    
    -- GreenLeaf Organics campaigns
    (109, 4, 'Organic Snacks', 'Sponsored Products', 'Manual', 2200, '2025-01-01', 'Active'),
    (110, 4, 'Green Cleaning Products', 'Sponsored Display', 'Auto', 1500, '2025-01-20', 'Active'),
    
    -- StyleHub Fashion campaigns
    (111, 5, 'Winter Collection', 'Sponsored Products', 'Manual', 3200, '2025-01-01', 'Active'),
    (112, 5, 'Accessories Campaign', 'Sponsored Brands', 'Manual', 2800, '2025-01-01', 'Active');

-- =====================================================
-- Generate Daily Metrics for January 2025
-- This creates realistic performance data with trends
-- =====================================================

-- TechGear Pro - Premium Headphones (High performer)
INSERT INTO campaign_daily_metrics (campaign_id, date, impressions, clicks, spend, conversions, revenue)
SELECT 
    101 as campaign_id,
    DATE('2025-01-01', '+' || (value - 1) || ' days') as date,
    12000 + CAST((RANDOM() & 2047) AS INTEGER) as impressions,
    180 + CAST((RANDOM() & 31) AS INTEGER) as clicks,
    2200 + CAST((RANDOM() & 511) AS INTEGER) as spend,
    22 + CAST((RANDOM() & 7) AS INTEGER) as conversions,
    3300 + CAST((RANDOM() & 1023) AS INTEGER) as revenue
FROM (SELECT 1 as value UNION SELECT 2 UNION SELECT 3 UNION SELECT 4 UNION SELECT 5 UNION 
      SELECT 6 UNION SELECT 7 UNION SELECT 8 UNION SELECT 9 UNION SELECT 10 UNION 
      SELECT 11 UNION SELECT 12 UNION SELECT 13 UNION SELECT 14 UNION SELECT 15 UNION
      SELECT 16 UNION SELECT 17 UNION SELECT 18 UNION SELECT 19 UNION SELECT 20 UNION
      SELECT 21 UNION SELECT 22 UNION SELECT 23 UNION SELECT 24 UNION SELECT 25 UNION
      SELECT 26 UNION SELECT 27 UNION SELECT 28 UNION SELECT 29 UNION SELECT 30 UNION SELECT 31);

-- TechGear Pro - Smart Watches (Medium performer)
INSERT INTO campaign_daily_metrics (campaign_id, date, impressions, clicks, spend, conversions, revenue)
SELECT 
    102 as campaign_id,
    DATE('2025-01-01', '+' || (value - 1) || ' days') as date,
    15000 + CAST((RANDOM() & 2047) AS INTEGER) as impressions,
    200 + CAST((RANDOM() & 63) AS INTEGER) as clicks,
    2800 + CAST((RANDOM() & 511) AS INTEGER) as spend,
    18 + CAST((RANDOM() & 7) AS INTEGER) as conversions,
    2700 + CAST((RANDOM() & 1023) AS INTEGER) as revenue
FROM (SELECT 1 as value UNION SELECT 2 UNION SELECT 3 UNION SELECT 4 UNION SELECT 5 UNION 
      SELECT 6 UNION SELECT 7 UNION SELECT 8 UNION SELECT 9 UNION SELECT 10 UNION 
      SELECT 11 UNION SELECT 12 UNION SELECT 13 UNION SELECT 14 UNION SELECT 15 UNION
      SELECT 16 UNION SELECT 17 UNION SELECT 18 UNION SELECT 19 UNION SELECT 20 UNION
      SELECT 21 UNION SELECT 22 UNION SELECT 23 UNION SELECT 24 UNION SELECT 25 UNION
      SELECT 26 UNION SELECT 27 UNION SELECT 28 UNION SELECT 29 UNION SELECT 30 UNION SELECT 31);

-- TechGear Pro - Gaming Accessories (Started Jan 15)
INSERT INTO campaign_daily_metrics (campaign_id, date, impressions, clicks, spend, conversions, revenue)
SELECT 
    103 as campaign_id,
    DATE('2025-01-15', '+' || (value - 1) || ' days') as date,
    8000 + CAST((RANDOM() & 1023) AS INTEGER) as impressions,
    120 + CAST((RANDOM() & 31) AS INTEGER) as clicks,
    1400 + CAST((RANDOM() & 255) AS INTEGER) as spend,
    12 + CAST((RANDOM() & 3) AS INTEGER) as conversions,
    1800 + CAST((RANDOM() & 511) AS INTEGER) as revenue
FROM (SELECT 1 as value UNION SELECT 2 UNION SELECT 3 UNION SELECT 4 UNION SELECT 5 UNION 
      SELECT 6 UNION SELECT 7 UNION SELECT 8 UNION SELECT 9 UNION SELECT 10 UNION 
      SELECT 11 UNION SELECT 12 UNION SELECT 13 UNION SELECT 14 UNION SELECT 15 UNION
      SELECT 16 UNION SELECT 17);

-- HomeStyle Living - Kitchen Essentials (Top performer)
INSERT INTO campaign_daily_metrics (campaign_id, date, impressions, clicks, spend, conversions, revenue)
SELECT 
    104 as campaign_id,
    DATE('2025-01-01', '+' || (value - 1) || ' days') as date,
    20000 + CAST((RANDOM() & 4095) AS INTEGER) as impressions,
    320 + CAST((RANDOM() & 63) AS INTEGER) as clicks,
    3200 + CAST((RANDOM() & 511) AS INTEGER) as spend,
    40 + CAST((RANDOM() & 15) AS INTEGER) as conversions,
    5600 + CAST((RANDOM() & 2047) AS INTEGER) as revenue
FROM (SELECT 1 as value UNION SELECT 2 UNION SELECT 3 UNION SELECT 4 UNION SELECT 5 UNION 
      SELECT 6 UNION SELECT 7 UNION SELECT 8 UNION SELECT 9 UNION SELECT 10 UNION 
      SELECT 11 UNION SELECT 12 UNION SELECT 13 UNION SELECT 14 UNION SELECT 15 UNION
      SELECT 16 UNION SELECT 17 UNION SELECT 18 UNION SELECT 19 UNION SELECT 20 UNION
      SELECT 21 UNION SELECT 22 UNION SELECT 23 UNION SELECT 24 UNION SELECT 25 UNION
      SELECT 26 UNION SELECT 27 UNION SELECT 28 UNION SELECT 29 UNION SELECT 30 UNION SELECT 31);

-- HomeStyle Living - Home Decor
INSERT INTO campaign_daily_metrics (campaign_id, date, impressions, clicks, spend, conversions, revenue)
SELECT 
    105 as campaign_id,
    DATE('2025-01-01', '+' || (value - 1) || ' days') as date,
    18000 + CAST((RANDOM() & 2047) AS INTEGER) as impressions,
    280 + CAST((RANDOM() & 63) AS INTEGER) as clicks,
    3800 + CAST((RANDOM() & 511) AS INTEGER) as spend,
    30 + CAST((RANDOM() & 7) AS INTEGER) as conversions,
    4200 + CAST((RANDOM() & 1023) AS INTEGER) as revenue
FROM (SELECT 1 as value UNION SELECT 2 UNION SELECT 3 UNION SELECT 4 UNION SELECT 5 UNION 
      SELECT 6 UNION SELECT 7 UNION SELECT 8 UNION SELECT 9 UNION SELECT 10 UNION 
      SELECT 11 UNION SELECT 12 UNION SELECT 13 UNION SELECT 14 UNION SELECT 15 UNION
      SELECT 16 UNION SELECT 17 UNION SELECT 18 UNION SELECT 19 UNION SELECT 20 UNION
      SELECT 21 UNION SELECT 22 UNION SELECT 23 UNION SELECT 24 UNION SELECT 25 UNION
      SELECT 26 UNION SELECT 27 UNION SELECT 28 UNION SELECT 29 UNION SELECT 30 UNION SELECT 31);

-- HomeStyle Living - Furniture Sale (Started Jan 10)
INSERT INTO campaign_daily_metrics (campaign_id, date, impressions, clicks, spend, conversions, revenue)
SELECT 
    106 as campaign_id,
    DATE('2025-01-10', '+' || (value - 1) || ' days') as date,
    14000 + CAST((RANDOM() & 2047) AS INTEGER) as impressions,
    210 + CAST((RANDOM() & 31) AS INTEGER) as clicks,
    1900 + CAST((RANDOM() & 255) AS INTEGER) as spend,
    20 + CAST((RANDOM() & 7) AS INTEGER) as conversions,
    2800 + CAST((RANDOM() & 1023) AS INTEGER) as revenue
FROM (SELECT 1 as value UNION SELECT 2 UNION SELECT 3 UNION SELECT 4 UNION SELECT 5 UNION 
      SELECT 6 UNION SELECT 7 UNION SELECT 8 UNION SELECT 9 UNION SELECT 10 UNION 
      SELECT 11 UNION SELECT 12 UNION SELECT 13 UNION SELECT 14 UNION SELECT 15 UNION
      SELECT 16 UNION SELECT 17 UNION SELECT 18 UNION SELECT 19 UNION SELECT 20 UNION
      SELECT 21 UNION SELECT 22);

-- FitLife Nutrition - Protein Powder (Good performer)
INSERT INTO campaign_daily_metrics (campaign_id, date, impressions, clicks, spend, conversions, revenue)
SELECT 
    107 as campaign_id,
    DATE('2025-01-01', '+' || (value - 1) || ' days') as date,
    11000 + CAST((RANDOM() & 2047) AS INTEGER) as impressions,
    160 + CAST((RANDOM() & 31) AS INTEGER) as clicks,
    1900 + CAST((RANDOM() & 255) AS INTEGER) as spend,
    25 + CAST((RANDOM() & 7) AS INTEGER) as conversions,
    3250 + CAST((RANDOM() & 1023) AS INTEGER) as revenue
FROM (SELECT 1 as value UNION SELECT 2 UNION SELECT 3 UNION SELECT 4 UNION SELECT 5 UNION 
      SELECT 6 UNION SELECT 7 UNION SELECT 8 UNION SELECT 9 UNION SELECT 10 UNION 
      SELECT 11 UNION SELECT 12 UNION SELECT 13 UNION SELECT 14 UNION SELECT 15 UNION
      SELECT 16 UNION SELECT 17 UNION SELECT 18 UNION SELECT 19 UNION SELECT 20 UNION
      SELECT 21 UNION SELECT 22 UNION SELECT 23 UNION SELECT 24 UNION SELECT 25 UNION
      SELECT 26 UNION SELECT 27 UNION SELECT 28 UNION SELECT 29 UNION SELECT 30 UNION SELECT 31);

-- FitLife Nutrition - Vitamins (Started Jan 5)
INSERT INTO campaign_daily_metrics (campaign_id, date, impressions, clicks, spend, conversions, revenue)
SELECT 
    108 as campaign_id,
    DATE('2025-01-05', '+' || (value - 1) || ' days') as date,
    9500 + CAST((RANDOM() & 1023) AS INTEGER) as impressions,
    140 + CAST((RANDOM() & 31) AS INTEGER) as clicks,
    1700 + CAST((RANDOM() & 255) AS INTEGER) as spend,
    18 + CAST((RANDOM() & 7) AS INTEGER) as conversions,
    2340 + CAST((RANDOM() & 511) AS INTEGER) as revenue
FROM (SELECT 1 as value UNION SELECT 2 UNION SELECT 3 UNION SELECT 4 UNION SELECT 5 UNION 
      SELECT 6 UNION SELECT 7 UNION SELECT 8 UNION SELECT 9 UNION SELECT 10 UNION 
      SELECT 11 UNION SELECT 12 UNION SELECT 13 UNION SELECT 14 UNION SELECT 15 UNION
      SELECT 16 UNION SELECT 17 UNION SELECT 18 UNION SELECT 19 UNION SELECT 20 UNION
      SELECT 21 UNION SELECT 22 UNION SELECT 23 UNION SELECT 24 UNION SELECT 25 UNION
      SELECT 26 UNION SELECT 27);

-- GreenLeaf Organics - Organic Snacks
INSERT INTO campaign_daily_metrics (campaign_id, date, impressions, clicks, spend, conversions, revenue)
SELECT 
    109 as campaign_id,
    DATE('2025-01-01', '+' || (value - 1) || ' days') as date,
    13000 + CAST((RANDOM() & 2047) AS INTEGER) as impressions,
    195 + CAST((RANDOM() & 31) AS INTEGER) as clicks,
    2100 + CAST((RANDOM() & 255) AS INTEGER) as spend,
    28 + CAST((RANDOM() & 7) AS INTEGER) as conversions,
    3640 + CAST((RANDOM() & 1023) AS INTEGER) as revenue
FROM (SELECT 1 as value UNION SELECT 2 UNION SELECT 3 UNION SELECT 4 UNION SELECT 5 UNION 
      SELECT 6 UNION SELECT 7 UNION SELECT 8 UNION SELECT 9 UNION SELECT 10 UNION 
      SELECT 11 UNION SELECT 12 UNION SELECT 13 UNION SELECT 14 UNION SELECT 15 UNION
      SELECT 16 UNION SELECT 17 UNION SELECT 18 UNION SELECT 19 UNION SELECT 20 UNION
      SELECT 21 UNION SELECT 22 UNION SELECT 23 UNION SELECT 24 UNION SELECT 25 UNION
      SELECT 26 UNION SELECT 27 UNION SELECT 28 UNION SELECT 29 UNION SELECT 30 UNION SELECT 31);

-- GreenLeaf Organics - Green Cleaning (Started Jan 20)
INSERT INTO campaign_daily_metrics (campaign_id, date, impressions, clicks, spend, conversions, revenue)
SELECT 
    110 as campaign_id,
    DATE('2025-01-20', '+' || (value - 1) || ' days') as date,
    8500 + CAST((RANDOM() & 1023) AS INTEGER) as impressions,
    125 + CAST((RANDOM() & 15) AS INTEGER) as clicks,
    1450 + CAST((RANDOM() & 127) AS INTEGER) as spend,
    15 + CAST((RANDOM() & 3) AS INTEGER) as conversions,
    1950 + CAST((RANDOM() & 511) AS INTEGER) as revenue
FROM (SELECT 1 as value UNION SELECT 2 UNION SELECT 3 UNION SELECT 4 UNION SELECT 5 UNION 
      SELECT 6 UNION SELECT 7 UNION SELECT 8 UNION SELECT 9 UNION SELECT 10 UNION 
      SELECT 11 UNION SELECT 12);

-- StyleHub Fashion - Winter Collection
INSERT INTO campaign_daily_metrics (campaign_id, date, impressions, clicks, spend, conversions, revenue)
SELECT 
    111 as campaign_id,
    DATE('2025-01-01', '+' || (value - 1) || ' days') as date,
    16000 + CAST((RANDOM() & 2047) AS INTEGER) as impressions,
    240 + CAST((RANDOM() & 63) AS INTEGER) as clicks,
    3000 + CAST((RANDOM() & 511) AS INTEGER) as spend,
    32 + CAST((RANDOM() & 7) AS INTEGER) as conversions,
    4480 + CAST((RANDOM() & 1023) AS INTEGER) as revenue
FROM (SELECT 1 as value UNION SELECT 2 UNION SELECT 3 UNION SELECT 4 UNION SELECT 5 UNION 
      SELECT 6 UNION SELECT 7 UNION SELECT 8 UNION SELECT 9 UNION SELECT 10 UNION 
      SELECT 11 UNION SELECT 12 UNION SELECT 13 UNION SELECT 14 UNION SELECT 15 UNION
      SELECT 16 UNION SELECT 17 UNION SELECT 18 UNION SELECT 19 UNION SELECT 20 UNION
      SELECT 21 UNION SELECT 22 UNION SELECT 23 UNION SELECT 24 UNION SELECT 25 UNION
      SELECT 26 UNION SELECT 27 UNION SELECT 28 UNION SELECT 29 UNION SELECT 30 UNION SELECT 31);

-- StyleHub Fashion - Accessories
INSERT INTO campaign_daily_metrics (campaign_id, date, impressions, clicks, spend, conversions, revenue)
SELECT 
    112 as campaign_id,
    DATE('2025-01-01', '+' || (value - 1) || ' days') as date,
    14000 + CAST((RANDOM() & 2047) AS INTEGER) as impressions,
    210 + CAST((RANDOM() & 31) AS INTEGER) as clicks,
    2700 + CAST((RANDOM() & 511) AS INTEGER) as spend,
    27 + CAST((RANDOM() & 7) AS INTEGER) as conversions,
    3510 + CAST((RANDOM() & 1023) AS INTEGER) as revenue
FROM (SELECT 1 as value UNION SELECT 2 UNION SELECT 3 UNION SELECT 4 UNION SELECT 5 UNION 
      SELECT 6 UNION SELECT 7 UNION SELECT 8 UNION SELECT 9 UNION SELECT 10 UNION 
      SELECT 11 UNION SELECT 12 UNION SELECT 13 UNION SELECT 14 UNION SELECT 15 UNION
      SELECT 16 UNION SELECT 17 UNION SELECT 18 UNION SELECT 19 UNION SELECT 20 UNION
      SELECT 21 UNION SELECT 22 UNION SELECT 23 UNION SELECT 24 UNION SELECT 25 UNION
      SELECT 26 UNION SELECT 27 UNION SELECT 28 UNION SELECT 29 UNION SELECT 30 UNION SELECT 31);

-- =====================================================
-- DATABASE CREATED SUCCESSFULLY
-- =====================================================
