import pandas as pd
import matplotlib.pyplot as plt
import numpy as np

# Set style for professional visualizations
plt.style.use('seaborn-v0_8-darkgrid')
plt.rcParams['figure.figsize'] = (12, 8)
plt.rcParams['font.size'] = 10

# Year 1-5 Projections
years = ['Year 1', 'Year 2', 'Year 3', 'Year 4', 'Year 5']

# Developer Growth (assuming viral growth pattern)
developers = [500, 2000, 6000, 15000, 30000]

# Enterprise Customer Growth (more conservative)
enterprise_basic = [50, 200, 500, 1000, 1800]
enterprise_professional = [10, 50, 150, 350, 650]
enterprise_enterprise = [2, 10, 30, 75, 150]

# Subscription Pricing (annual)
basic_price = 5000  # $5,000/year
professional_price = 25000  # $25,000/year
enterprise_price = 100000  # $100,000/year

# Transaction Volume (average licensing transactions per developer per year)
avg_transactions_per_dev = [2, 3, 4, 5, 6]
avg_transaction_value = [1000, 1200, 1500, 1800, 2000]

# Calculate Revenue Streams
subscription_revenue = []
transaction_revenue = []
value_added_services = []

for i in range(5):
    # Subscription Revenue
    sub_rev = (enterprise_basic[i] * basic_price + 
               enterprise_professional[i] * professional_price + 
               enterprise_enterprise[i] * enterprise_price)
    subscription_revenue.append(sub_rev)
    
    # Transaction Revenue (15% of total transaction value)
    total_transactions = developers[i] * avg_transactions_per_dev[i]
    total_transaction_value = total_transactions * avg_transaction_value[i]
    trans_rev = total_transaction_value * 0.15
    transaction_revenue.append(trans_rev)
    
    # Value-Added Services (10% of total revenue in early years, growing to 15%)
    vas_percentage = 0.10 + (i * 0.01)
    vas = (sub_rev + trans_rev) * vas_percentage
    value_added_services.append(vas)

# Total Revenue
total_revenue = [subscription_revenue[i] + transaction_revenue[i] + value_added_services[i] 
                 for i in range(5)]

# Developer Earnings (85% of transaction value)
developer_earnings = [developers[i] * avg_transactions_per_dev[i] * avg_transaction_value[i] * 0.85 
                      for i in range(5)]

# Cost Structure (as percentage of revenue)
# Year 1: Higher costs due to initial investment
# Years 2-5: Improving margins as platform scales
cost_percentages = [0.85, 0.75, 0.65, 0.60, 0.55]

platform_costs = []
rd_costs = []
sales_marketing_costs = []
admin_costs = []
total_costs = []

for i in range(5):
    total_cost = total_revenue[i] * cost_percentages[i]
    
    # Break down costs
    platform = total_cost * 0.30  # Infrastructure
    rd = total_cost * 0.35  # R&D
    sales_marketing = total_cost * 0.25  # Sales & Marketing
    admin = total_cost * 0.10  # Admin
    
    platform_costs.append(platform)
    rd_costs.append(rd)
    sales_marketing_costs.append(sales_marketing)
    admin_costs.append(admin)
    total_costs.append(total_cost)

# Operating Profit
operating_profit = [total_revenue[i] - total_costs[i] for i in range(5)]

# Create DataFrame for export
financial_data = pd.DataFrame({
    'Year': years,
    'Developers': developers,
    'Enterprise Customers (Total)': [enterprise_basic[i] + enterprise_professional[i] + enterprise_enterprise[i] 
                                     for i in range(5)],
    'Subscription Revenue ($)': subscription_revenue,
    'Transaction Revenue ($)': transaction_revenue,
    'Value-Added Services ($)': value_added_services,
    'Total Revenue ($)': total_revenue,
    'Developer Earnings ($)': developer_earnings,
    'Total Costs ($)': total_costs,
    'Operating Profit ($)': operating_profit,
    'Operating Margin (%)': [(operating_profit[i] / total_revenue[i] * 100) for i in range(5)]
})

# Save to CSV
financial_data.to_csv('/home/ubuntu/nightmoves_financial_projections.csv', index=False)

# Create visualizations
fig, axes = plt.subplots(2, 2, figsize=(16, 12))

# 1. Revenue Growth
ax1 = axes[0, 0]
x = np.arange(len(years))
width = 0.6

ax1.bar(x, subscription_revenue, width, label='Subscription Revenue', color='#2E86AB')
ax1.bar(x, transaction_revenue, width, bottom=subscription_revenue, 
        label='Transaction Revenue', color='#A23B72')
ax1.bar(x, value_added_services, width, 
        bottom=[subscription_revenue[i] + transaction_revenue[i] for i in range(5)],
        label='Value-Added Services', color='#F18F01')

ax1.set_xlabel('Year', fontweight='bold')
ax1.set_ylabel('Revenue ($)', fontweight='bold')
ax1.set_title('Revenue Growth by Stream (5-Year Projection)', fontweight='bold', fontsize=12)
ax1.set_xticks(x)
ax1.set_xticklabels(years)
ax1.legend()
ax1.grid(axis='y', alpha=0.3)

# Format y-axis as currency
ax1.yaxis.set_major_formatter(plt.FuncFormatter(lambda x, p: f'${x/1e6:.1f}M'))

# 2. User Growth
ax2 = axes[0, 1]
ax2_twin = ax2.twinx()

line1 = ax2.plot(years, developers, marker='o', linewidth=2.5, 
                 color='#2E86AB', label='Developers')
ax2.set_xlabel('Year', fontweight='bold')
ax2.set_ylabel('Developers', fontweight='bold', color='#2E86AB')
ax2.tick_params(axis='y', labelcolor='#2E86AB')

enterprise_total = [enterprise_basic[i] + enterprise_professional[i] + enterprise_enterprise[i] 
                    for i in range(5)]
line2 = ax2_twin.plot(years, enterprise_total, marker='s', linewidth=2.5, 
                      color='#A23B72', label='Enterprise Customers')
ax2_twin.set_ylabel('Enterprise Customers', fontweight='bold', color='#A23B72')
ax2_twin.tick_params(axis='y', labelcolor='#A23B72')

ax2.set_title('User Growth (5-Year Projection)', fontweight='bold', fontsize=12)
ax2.grid(True, alpha=0.3)

# Combine legends
lines1, labels1 = ax2.get_legend_handles_labels()
lines2, labels2 = ax2_twin.get_legend_handles_labels()
ax2.legend(lines1 + lines2, labels1 + labels2, loc='upper left')

# 3. Profitability
ax3 = axes[1, 0]
ax3.plot(years, total_revenue, marker='o', linewidth=2.5, 
         color='#2E86AB', label='Total Revenue')
ax3.plot(years, total_costs, marker='s', linewidth=2.5, 
         color='#A23B72', label='Total Costs')
ax3.plot(years, operating_profit, marker='^', linewidth=2.5, 
         color='#06A77D', label='Operating Profit')

ax3.set_xlabel('Year', fontweight='bold')
ax3.set_ylabel('Amount ($)', fontweight='bold')
ax3.set_title('Revenue, Costs, and Profitability (5-Year Projection)', fontweight='bold', fontsize=12)
ax3.legend()
ax3.grid(True, alpha=0.3)
ax3.yaxis.set_major_formatter(plt.FuncFormatter(lambda x, p: f'${x/1e6:.1f}M'))

# 4. Shared Value - Developer Earnings vs Platform Revenue
ax4 = axes[1, 1]
x = np.arange(len(years))
width = 0.35

ax4.bar(x - width/2, developer_earnings, width, label='Developer Earnings (85%)', 
        color='#06A77D')
ax4.bar(x + width/2, transaction_revenue, width, label='Platform Transaction Revenue (15%)', 
        color='#F18F01')

ax4.set_xlabel('Year', fontweight='bold')
ax4.set_ylabel('Amount ($)', fontweight='bold')
ax4.set_title('Shared Value: Developer Earnings vs Platform Revenue', fontweight='bold', fontsize=12)
ax4.set_xticks(x)
ax4.set_xticklabels(years)
ax4.legend()
ax4.grid(axis='y', alpha=0.3)
ax4.yaxis.set_major_formatter(plt.FuncFormatter(lambda x, p: f'${x/1e6:.1f}M'))

plt.tight_layout()
plt.savefig('/home/ubuntu/nightmoves_financial_projections.png', dpi=300, bbox_inches='tight')
print("Financial projections visualization saved successfully!")

# Create a detailed breakdown table
print("\n=== NightMoves Financial Projections (5-Year) ===\n")
print(financial_data.to_string(index=False))

# Additional metrics
print("\n=== Key Metrics ===")
print(f"Total 5-Year Revenue: ${sum(total_revenue):,.0f}")
print(f"Total 5-Year Developer Earnings: ${sum(developer_earnings):,.0f}")
print(f"Year 5 Operating Margin: {operating_profit[4]/total_revenue[4]*100:.1f}%")
print(f"Developer-to-Enterprise Ratio (Year 5): {developers[4]/(enterprise_basic[4]+enterprise_professional[4]+enterprise_enterprise[4]):.1f}:1")
