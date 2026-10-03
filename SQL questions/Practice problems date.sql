SELECT
 count(job_id) AS total_jobs,
    EXTRACT(MONTH FROM (job_posted_date AT TIME ZONE 'UTC' AT TIME ZONE 'America/New_York')) AS Month
FROM job_postings_fact
WHERE job_posted_date BETWEEN '2023-01-01' AND '2023-12-31'
Group BY EXTRACT(MONTH FROM (job_posted_date AT TIME ZONE 'UTC' AT TIME ZONE 'America/New_York')) 

Order BY Month;

--Answer
SELECT
    EXTRACT(MONTH FROM (job_posted_date AT TIME ZONE 'UTC' AT TIME ZONE 'America/New_York')) AS month,
    COUNT(job_id) AS total_jobs
FROM job_postings_fact
WHERE job_posted_date >= '2023-01-01'
  AND job_posted_date < '2024-01-01'
GROUP BY
    EXTRACT(MONTH FROM (job_posted_date AT TIME ZONE 'UTC' AT TIME ZONE 'America/New_York'))
ORDER BY month;