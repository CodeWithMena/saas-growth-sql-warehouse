# Enterprise SaaS Product Growth & Relational SQL Data Warehouse

# Project Overview
This repository features a production-grade, pure SQL implementation mapping out the backend relational data architecture for a fast-scaling SaaS platform. The system manages structural relational integrity (DDL constraints, check parameters, and cascading triggers) across multiple business entities to track customer signups, monitor product features, and analyze real-time Monthly Recurring Revenue ($MRR$) pipelines.

## 🛠️ Stack & Database Architectures
* **Languages:** Pure ANSI SQL (Compatible with PostgreSQL, Snowflake, BigQuery)
* **Design Pattern:** Normalization Layer with Dimensional Reporting Schemas
* **Advanced Code Structures:** CTE Foundations, Window Ranking Engine (`DENSE_RANK() OVER`), Check Enforcements, Cascading Foreign Constraints

---

## 📐 Relational Data Architecture
The warehouse is built on an interconnected star schema schema mapping customer interaction metrics directly to financial bottom lines:
1. `dim_accounts`: Tracks structural corporate accounts, tier thresholds, and market locations.
2. `dim_user_events`: Ingests high-velocity event streams tracking user action types across application interfaces.
3. `fact_subscriptions`: Captures critical financial snapshots monitoring Monthly Recurring Revenue ($MRR$), activation timelines, and contractual cancellation dates.

---

## 📊 Analytical Pipeline Insights
The script contains optimization blocks running advanced analytical joins to answer operational product performance markers:
* **Product Tier Performance:** Aggregates ARR profiles dynamically to isolate high-value enterprise revenue trends from lower baseline structures.
* **Feature Activation Funnel Partitioning:** Deploys a dense-ranking analytical matrix over user behavior streams to automatically identify which specific technical tools drive maximum engagement within paid accounts—giving product managers clear signals on long-term client retention vectors.
