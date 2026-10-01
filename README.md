# Customer Behavior Analysis

This is an end-to-end retail analytics project that takes customer shopping records from a CSV file. It prepares them with Python, explores purchase patterns in PostgreSQL, and presents key results in an interactive Power BI dashboard. The analysis looks at revenue, products, customer groups, discounts, subscriptions, shipping choices, and review ratings.

## Tools used

In this project i used python and specifically the pandas library to perform data cleaning, missing value imputation by median, and to create analysis-ready fields. I have also used PostgreSQL to store the processed records and answer business questions with SQL.I also made use of SQLAlchemy and pyscopg2 to load the cleaned csv from python to sql and finally I used Power BI for visualizations.

## 

## What is in this project

|File|Purpose|
|-|-|
|`preprocessing.py`|Reads `data/raw/customer\_shopping\_behavior.csv`, cleans and enriches it, and saves `data/processed/customer\_shopping\_clean.csv`.|
|`load\_to\_postgres.py`|Prompts for the local PostgreSQL password, checks the connection, and loads the processed CSV into the `customer` table of the `customer\_behavior` database.|
|`customer-behavior-analysis.sql`|Contains ten business questions explored with aggregations, subqueries, conditional counts, a common table expression, and a window function.|
|`customer\_behavior\_dashboard.pbix`|Power BI dashboard with summary cards, category and age group comparisons, subscription breakdown, and filters.|

The Python preprocessing script fills missing review ratings with the **median rating within each category**, standardizes column names to lowercase with underscores, and renames `purchase\_amount\_(usd)` to `purchase\_amount`. It also creates `age\_group` using four age quantiles and maps reported purchase frequency to an approximate `time\_between\_purchase` in days. Finally, it drops `promo\_code\_used` before exporting the cleaned CSV.

The SQL analysis investigates revenue by gender and age group; above-average spending among discount users; highest-rated products; Standard versus Express shipping; subscriber versus non-subscriber spending; discount use by product; customer segments based on previous purchases; popular products within each category; and subscription among customers with more than five previous purchases.

## Dashboard

The dashboard displays the number of customers, average purchase amount, and average review rating. It compares revenue and sales across product categories and age groups, shows the subscription split, and provides filters for subscription status, gender, category, and shipping type. Open `customer\_behavior\_dashboard.pbix` in Power BI Desktop to explore the interactive report.

## Findings

The dashboard view supplied with this project shows:

* Approximately **3.9K customer records**, an **average purchase amount of $59.76**, and an **average review rating of 3.75**.
* **27%** of customers are marked as subscribers; **73%** are non-subscribers.
* **Clothing** leads the displayed categories in both revenue and sales count.
* The **Young Adult** age group leads the displayed age groups in revenue and sales count.

These are observations from the dashboard's shown view; filter selections can change the figures. The SQL queries provide additional ways to investigate relationships, but the project does not establish that a discount, subscription, or shipping choice *causes* customers to spend more.

## What I learned

* How to turn a raw CSV into consistent, analysis-ready data with pandas.
* How to engineer age and purchase-frequency fields while documenting what they mean.
* How to move a processed dataset into a relational database and query it with PostgreSQL.
* How `GROUP BY`, aggregates, conditional counts, subqueries, CTEs, and window functions answer different business questions.
* How to turn queryable data into a Power BI report that lets viewers compare customer groups and product categories.

## Running the pipeline locally

1. Place the source dataset at `data/raw/customer\_shopping\_behavior.csv`. Create the `data/processed` folder if it does not exist. The source CSV is required to regenerate the processed data.
2. Install the Python dependencies:

```bash
   pip install pandas sqlalchemy psycopg2-binary
   ```

3. Create a local PostgreSQL database named `customer\_behavior` and ensure PostgreSQL is available on `localhost:5432` with a `postgres` user.
4. From the project root, run:

```bash
   python preprocessing.py
   python load\_to\_postgres.py
   ```

5. Enter the PostgreSQL password when prompted. Run the analysis queries in `customer-behavior-analysis.sql` against the `customer\_behavior` database, and open the `.pbix` file in Power BI Desktop.

**SQL note:** The queries in the supplied SQL file are best run individually because several are not separated by semicolons. Question 6 also needs `ORDER BY discount\_rate DESC` in place of `ORDER BY discount\_percentage DESC` to match its defined alias. Running `load\_to\_postgres.py` again replaces the existing `customer` table.

## Data scope

This is an exploratory analysis of the supplied shopping dataset. `age\_group` is based on quantiles of this dataset, so its labels are relative to the data rather than fixed age brackets. `time\_between\_purchase` is an approximate mapping from a reported frequency, not an observed interval between dated transactions. Comparisons of previous purchases use the dataset's `previous\_purchases` field rather than a reconstructed order history.

