from getpass import getpass

import pandas as pd
from sqlalchemy import create_engine, text
from sqlalchemy.engine import URL

# 1. Read the CSV created by preprocessing.py
df = pd.read_csv("data/processed/customer_shopping_clean.csv")

# 2. Connect to your local PostgreSQL database
password = getpass("PostgreSQL postgres password: ")

url = URL.create(
    "postgresql+psycopg2",
    username="postgres",
    password=password,
    host="localhost",
    port=5432,
    database="customer_behavior",
)

engine = create_engine(url)

# 3. Check the connection
with engine.connect() as connection:
    print("Connection test:", connection.execute(text("SELECT 1")).scalar_one())

# 4. Load the cleaned data
df.to_sql("customer", engine, if_exists="replace", index=False)
print("Cleaned data loaded into the customer table.")
