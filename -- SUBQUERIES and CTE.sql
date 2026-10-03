-- SUBQUERIES and CTE

SELECT *
FROM (--subquery Starts here
    Select *
    FROM job_postings_fact
    WHERE EXTRACT(MONTH FROM job_posted_date) = 1 
) AS January_jobs;
--subquery Ends here

WITH january_jobs AS ( -- CTE definition starts here
    SELECT *
    FROM job_postings_fact
    WHERE EXTRACT(MONTH FROM job_posted_date) = 1
) -- CTE definition ends here
SELECT *
FROM january_jobs;