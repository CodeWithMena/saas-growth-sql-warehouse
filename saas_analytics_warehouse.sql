– ====================================================================
– PROJECT 5: ENTERPRISE SaaS USER ENGAGEMENT & CONVERSION SQL WAREHOUSE
– TARGET ENVIRONMENT: PostgreSQL / Snowflake / BigQuery
– ARCHITECTURE: Relational Schema with Dimensional Performance Layer
– ====================================================================

– 🏢 PHASE 1: DATABASE SCHEMA DEFINITION & CONSTRAINTS
DROP TABLE IF EXISTS fact_subscriptions CASCADE;
DROP TABLE IF EXISTS dim_user_events CASCADE;
DROP TABLE IF EXISTS dim_accounts CASCADE;

CREATE TABLE dim_accounts (
account_id VARCHAR(50) PRIMARY KEY,
company_name VARCHAR(100),
industry VARCHAR(50),
signup_date DATE NOT NULL,
tier VARCHAR(20) CHECK (tier IN (‘Free’, ‘Growth’, ‘Enterprise’)),
country VARCHAR(50)
);

CREATE TABLE dim_user_events (
event_id SERIAL PRIMARY KEY,
account_id VARCHAR(50) REFERENCES dim_accounts(account_id),
user_id VARCHAR(50) NOT NULL,
session_id VARCHAR(50) NOT NULL,
event_timestamp TIMESTAMP NOT NULL,
feature_action VARCHAR(50) NOT NULL, – e.g., ‘Dashboard_View’, ‘Export_Data’
device_type VARCHAR(20)
);

CREATE TABLE fact_subscriptions (
subscription_id SERIAL PRIMARY KEY,
account_id VARCHAR(50) REFERENCES dim_accounts(account_id),
billing_cycle_start DATE NOT NULL,
mrr_amount NUMERIC(10, 2) NOT NULL, – Monthly Recurring Revenue
is_active BOOLEAN DEFAULT TRUE,
churn_date DATE
);

– 📥 PHASE 2: INJECT SIMULATED PERFORMANCE SEED DATA
INSERT INTO dim_accounts VALUES
(‘ACC-001’, ‘Apex Media Dubai’, ‘Marketing’, ‘2025-01-15’, ‘Growth’, ‘UAE’),
(‘ACC-002’, ‘Velo Tech London’, ‘SaaS’, ‘2025-02-10’, ‘Enterprise’, ‘UK’),
(‘ACC-003’, ‘Delta Logistics’, ‘Logistics’, ‘2025-03-01’, ‘Free’, ‘Nigeria’);

INSERT INTO fact_subscriptions (account_id, billing_cycle_start, mrr_amount, is_active, churn_date) VALUES
(‘ACC-001’, ‘2025-01-15’, 499.00, TRUE, NULL),
(‘ACC-002’, ‘2025-02-10’, 2499.00, TRUE, NULL),
(‘ACC-003’, ‘2025-03-01’, 0.00, FALSE, ‘2025-04-15’);

INSERT INTO dim_user_events (account_id, user_id, session_id, event_timestamp, feature_action, device_type) VALUES
(‘ACC-001’, ‘USR-10A’, ‘SESS-99’, ‘2026-05-10 09:15:00’, ‘Dashboard_View’, ‘Web’),
(‘ACC-001’, ‘USR-10A’, ‘SESS-99’, ‘2026-05-10 09:18:20’, ‘Export_Data’, ‘Web’),
(‘ACC-002’, ‘USR-20B’, ‘SESS-88’, ‘2026-05-11 14:02:11’, ‘API_Integration’, ‘Web’),
(‘ACC-003’, ‘USR-30C’, ‘SESS-77’, ‘2026-05-12 18:22:00’, ‘Dashboard_View’, ‘Mobile’);

– ====================================================================
– 📊 PHASE 3: ADVANCED ENTERPRISE ANALYTICAL BUSINESS QUERIES
– ====================================================================

– 🔥 QUERY 1: REVENUE VELOCITY & MRR PERFORMANCE AUDIT
– Tracks total active expansion income vs revenue leaks from churned tiers
SELECT
a.tier AS Product_Tier,
COUNT(DISTINCT f.account_id) AS Active_Account_Count,
SUM(f.mrr_amount) AS Total_Active_MRR,
ROUND(AVG(f.mrr_amount), 2) AS Average_Contract_Value
FROM fact_subscriptions f
JOIN dim_accounts a ON f.account_id = a.account_id
WHERE f.is_active = TRUE
GROUP BY a.tier
ORDER BY Total_Active_MRR DESC;

– 🛡️ QUERY 2: GRANULAR CUSTOMER RETENTION & USER ACTIVATION FUNNEL
– Uses advanced Window Partitioning to isolate feature-adoption behavior
– inside companies to catch churn indicators before they cancel.
WITH FeatureRankedLogs AS (
SELECT
a.company_name AS Client_Company,
a.tier AS Service_Tier,
e.feature_action AS Interacted_Feature,
COUNT(e.event_id) AS Event_Frequency,
DENSE_RANK() OVER (PARTITION BY a.tier ORDER BY COUNT(e.event_id) DESC) as Feature_Popularity_Rank
FROM dim_user_events e
JOIN dim_accounts a ON e.account_id = a.account_id
GROUP BY a.company_name, a.tier, e.feature_action
)
SELECT
Client_Company,
Service_Tier,
Interacted_Feature,
Event_Frequency
FROM FeatureRankedLogs
WHERE Feature_Popularity_Rank <= 2;
Is this okay?
