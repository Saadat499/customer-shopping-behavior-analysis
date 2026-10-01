import pandas as pd

df = pd.read_csv("data/raw/customer_shopping_behavior.csv")

#print(df.head(10))
#print(df.info())
#print(df.describe(include="all"))
#print(df.isnull().sum())
df["Review Rating"] = df.groupby("Category")["Review Rating"].transform(lambda x: x.fillna(x.median()))
#print(df.isnull().sum())
df.columns = df.columns.str.lower()
df.columns = df.columns.str.replace(" ", "_")
df = df.rename(columns={'purchase_amount_(usd)': 'purchase_amount'})

##I will create a new column named age_group
labels = ["Young Adult", "Adult", "Middle-aged", "Senior"]
df["age_group"] = pd.qcut(df["age"], q=4, labels=labels) 
print(df[["age", "age_group"]].head(10)) 

## Create another new column named time_between_purchase
frequency_mapping = {
    "Fortnightly": 14,
    "Weekly" : 7,
    "Monthly" : 30,
    "Quarterly" : 90,
    "Bi-Weekly": 14,
    "Annually": 365,
    "Every 3 months": 90

}

df["time_between_purchase"] = df["frequency_of_purchases"].map(frequency_mapping)
print(df[["time_between_purchase", "frequency_of_purchases"]].head(10))

df = df.drop(columns="promo_code_used")

df.to_csv("data/processed/customer_shopping_clean.csv", index=False)
print("Saved cleaned CSV.")