"""
generate_data.py
----------------
Generates a synthetic retail transactions dataset (1 000+ rows, 400+ customers)
and saves it to data/retail_transactions.csv.

Run once before executing the main analysis notebook or SQL scripts.
"""

import numpy as np
import pandas as pd
from datetime import datetime, timedelta

SEED          = 42
N_CUSTOMERS   = 450
N_TRANSACTIONS = 1200
SNAPSHOT_DATE = datetime(2024, 12, 31)
PRODUCTS      = ['Electronics', 'Apparel', 'Home & Kitchen', 'Books',
                 'Sports', 'Beauty', 'Toys', 'Grocery']

np.random.seed(SEED)

# ── Customer master ──────────────────────────────────────────────────────────
customer_ids = [f'C{str(i).zfill(4)}' for i in range(1, N_CUSTOMERS + 1)]

# ── Transactions ─────────────────────────────────────────────────────────────
records = []
for _ in range(N_TRANSACTIONS):
    cid       = np.random.choice(customer_ids)
    days_ago  = np.random.exponential(scale=90)          # skewed recency
    order_dt  = SNAPSHOT_DATE - timedelta(days=days_ago)
    amount    = round(np.random.lognormal(mean=4.5, sigma=0.8), 2)   # ~₹90–₹10 000
    product   = np.random.choice(PRODUCTS)
    records.append({
        'order_id':       f'ORD{np.random.randint(10000, 99999)}',
        'customer_id':    cid,
        'order_date':     order_dt.strftime('%Y-%m-%d'),
        'amount':         amount,
        'product_category': product,
        'quantity':       np.random.randint(1, 6),
    })

df = pd.DataFrame(records).sort_values('order_date').reset_index(drop=True)

# Ensure at least 400 unique customers appear
assert df['customer_id'].nunique() >= 400, "Not enough unique customers — re-seed."

output_path = 'data/retail_transactions.csv'
df.to_csv(output_path, index=False)
print(f"Generated {len(df)} transactions for {df['customer_id'].nunique()} customers.")
print(f"Saved to {output_path}")
