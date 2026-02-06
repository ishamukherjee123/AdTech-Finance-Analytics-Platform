#!/bin/bash

# Amazon Ads Analytics Platform - Quick Start Script

echo "=================================================="
echo "Amazon Ads Finance Analytics Platform"
echo "Quick Start Setup"
echo "=================================================="
echo ""

# Step 1: Build Database
echo "Step 1: Building SQLite database..."
python build_db.py
if [ $? -eq 0 ]; then
    echo "✓ Database created successfully"
else
    echo "✗ Database creation failed"
    exit 1
fi
echo ""

# Step 2: Run Analytics
echo "Step 2: Running SQL analytics queries..."
python run_analysis.py
if [ $? -eq 0 ]; then
    echo "✓ Analytics completed successfully"
else
    echo "✗ Analytics failed"
    exit 1
fi
echo ""

# Step 3: Instructions
echo "=================================================="
echo "Setup Complete! 🎉"
echo "=================================================="
echo ""
echo "Next Steps:"
echo "1. Open dashboard.html in your web browser"
echo "2. Review the SQL queries in analysis_queries.sql"
echo "3. Check README.md for full documentation"
echo ""
echo "To view the dashboard:"
echo "  - macOS:   open dashboard.html"
echo "  - Linux:   xdg-open dashboard.html"
echo "  - Windows: start dashboard.html"
echo ""
echo "=================================================="
