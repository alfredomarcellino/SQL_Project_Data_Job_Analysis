# Data Analyst Job Market Analysis

# Introduction

Dive into the data job market focusing on data analyst roles. This project explores top paying jobs, in demand skills, and where high demand meets high salary in data analytics.

All SQL queries used in this project can be found in the [project_sql folder](https://www.google.com/search?q=%2Fproject_sql).

---

# Background

Driven by a quest to navigate the data analyst job market more effectively, this project was born from a desire to pinpoint top paid and in demand skills, streamlining the work needed to find optimal jobs.

Data hails from the SQL course dataset, packed with insights on job titles, salaries, locations, and essential skills.

The questions I wanted to answer through my SQL queries were:

1. What are the top paying data analyst jobs?
2. What skills are required for these top paying jobs?
3. What skills are most in demand for data analysts?
4. Which skills are associated with higher salaries?
5. What are the most optimal skills to learn?

---

# Tools I Used

* **SQL:** The backbone of my analysis, allowing me to query the database and uncover key trends.
* **PostgreSQL:** The database management system chosen for storing and querying job postings data.
* **Visual Studio Code:** My primary code editor for writing scripts and executing queries.
* **Git and GitHub:** Essential for version control, tracking project history, and sharing analysis online.

---

# The Analysis

### 1. Top Paying Data Analyst Jobs

To identify the highest paying roles, I filtered remote data analyst positions that included specified salaries, limiting the output to the top 10 results[cite: 5].

```sql
SELECT
    job_id,
    job_title,
    job_location,
    job_schedule_type,
    salary_year_avg,
    job_posted_date,
    name AS company_name
FROM
    job_postings_fact
LEFT JOIN company_dim ON job_postings_fact.company_id = company_dim.company_id
WHERE
    job_title_short = 'Data Analyst' AND
    job_location = 'Anywhere' AND
    salary_year_avg IS NOT NULL
ORDER BY salary_year_avg DESC
LIMIT 10;

```

**Results and Visualization**
![Top Paying Roles](assets\query_1_result.jpg)

* The highest reported remote data analyst salary reached $650,000 at Mantys.
* Executive and leadership titles like Director, Associate Director, and Principal skew salaries substantially above $200,000.
* Big tech and enterprise firms (Meta, AT&T, Pinterest, Disney) represent the dominant cluster for high compensation remote roles.

---

### 2. Skills Required for Top Paying Jobs

Building on query 1, this CTE joins the top 10 remote data analyst jobs with their associated skill requirements[cite: 1].

```sql
WITH top_paying_jobs AS (
    SELECT
        job_id,
        job_title,
        job_schedule_type,
        salary_year_avg,
        name AS company_name
    FROM
        job_postings_fact
    LEFT JOIN company_dim ON job_postings_fact.company_id = company_dim.company_id
    WHERE
        job_title_short = 'Data Analyst' AND
        job_location = 'Anywhere' AND
        salary_year_avg IS NOT NULL
    ORDER BY salary_year_avg DESC
    LIMIT 10
)

SELECT 
    top_paying_jobs.*,
    skills
FROM top_paying_jobs
INNER JOIN skills_job_dim ON top_paying_jobs.job_id = skills_job_dim.job_id
INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
ORDER BY salary_year_avg DESC;

```

**Results and Visualization**
![Top Paying Jobs](assets\query_2_result.jpg)


* SQL remains the undisputed leader, appearing in 8 of the top 10 postings.
* Python closely follows with 7 appearances, proving its role as the preferred programming language for advanced analytics.
* Tableau is the premier visualization platform, outperforming other BI tools in top compensation brackets.

---

### 3. In Demand Skills for Data Analysts

This query tallies the overall frequency of skills requested across all data analyst job postings, giving a view of market demand[cite: 2].

```sql
SELECT 
    skills,
    COUNT(skills_job_dim.skill_id) AS demand_count
FROM 
    job_postings_fact
INNER JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
WHERE job_title_short = 'Data Analyst'
GROUP BY skills
ORDER BY demand_count DESC
LIMIT 5;

```

**Results and Visualization**

![Top Demand Skills for Data Analysts](assets\query_3_result.jpg)

* SQL and Excel form the essential base, accounting for the highest total volume across data analyst positions.
* Python and Tableau constitute the middle tier, establishing candidates as modern technical analysts.
* Power BI continues strong growth, securing a top 5 presence alongside Tableau.

---

### 4. Top Skills Based on Salary

Exploring the average salary linked to individual skills reveals which specialized technologies command the highest pay[cite: 3].

```sql
SELECT 
    skills,
    ROUND(AVG(salary_year_avg), 0) AS avg_salary
FROM 
    job_postings_fact
INNER JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
WHERE job_title_short = 'Data Analyst' AND salary_year_avg IS NOT NULL
GROUP BY skills
ORDER BY avg_salary DESC
LIMIT 25;

```

**Results and Visualization**
![Top Skills Based On Salary](assets\query_4_result.jpg)


* Niche developer and engineering skills (SVN, Solidity, Couchbase, Golang) rank highest, often tied to low posting volumes or engineering adjacent roles.
* Machine learning and big data libraries (DataRobot, MXNet, PyTorch, Keras) demonstrate clear salary premiums over standard reporting tools.
* Cloud and infrastructure automation tools (Terraform, VMware, GitLab, Puppet) command high rates as data analyst roles overlap with data engineering.

---

### 5. Optimal Skills to Learn

Combining demand counts with salary averages isolates high value skills offering both job availability and strong compensation[cite: 4].

```sql
WITH skills_demand AS (
    SELECT 
        skills_dim.skill_id,
        skills_dim.skills,
        COUNT(skills_job_dim.job_id) AS demand_count
    FROM 
        job_postings_fact
    INNER JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
    INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
    WHERE job_title_short = 'Data Analyst' AND salary_year_avg IS NOT NULL
    GROUP BY skills_dim.skill_id
), 

average_salary AS (
    SELECT 
        skills_dim.skill_id,
        ROUND(AVG(job_postings_fact.salary_year_avg), 0) AS avg_salary
    FROM 
        job_postings_fact
    INNER JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
    INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
    WHERE job_title_short = 'Data Analyst' AND salary_year_avg IS NOT NULL
    GROUP BY skills_dim.skill_id
)

SELECT 
    skills_demand.skill_id,
    skills_demand.skills,
    demand_count,
    avg_salary
FROM skills_demand
INNER JOIN average_salary ON skills_demand.skill_id = average_salary.skill_id
ORDER BY 
    avg_salary DESC, demand_count DESC
LIMIT 25;

```

**Results and Visualization**
![top Optimal Skills to Learn](assets\query_5_result.jpg)
* Strict salary ordering surfaces rare niche skills (demand count 1–2) with inflated averages due to small sample sizes.
* Filtering for meaningful job counts (demand count 3 and higher) highlights clear optimal targets: Linux, Airflow, Scala, Kafka, and PyTorch.
* Modern data pipelines, data streaming, and machine learning integration deliver reliable compensation gains over traditional Excel and SQL workflows.

---

# What I Learned

* Advanced SQL Querying: Built multi table CTEs, integrated aggregate data, and managed subqueries for layered analysis.
* Data Aggregation: Applied GROUP BY routines along with COUNT, ROUND, and AVG functions to summarize large volume datasets.
* Real World Analytical Framing: Translated business questions about salary compensation and skills marketability into efficient SQL queries.

---

# Conclusions

### Insights

1. SQL and Excel represent the non negotiable baseline for volume and job postings availability across the industry.
2. Python and Tableau are mandatory competencies to breach six figure data analyst thresholds and access senior roles.
3. Pure salary leaders frequently feature data engineering, distributed computing, and machine learning tools (Kafka, PyTorch, Airflow).
4. Senior roles (Director, Principal, Lead) show the highest concentration of high paying remote postings.
5. True market sweet spots balance steady demand with technical specialization rather than hyper niche single posting anomalies.

### Closing Thoughts

Completing this analysis provided hands on experience querying relational databases and turning raw hiring data into clear career strategy takeaways. Mastering SQL fundamentals and layering technical pipeline skills offers the clearest roadmap to navigating the modern data job market.