-- CTE Practice Problem 1
WITH skill_counts AS (
    SELECT
        skill_id,
        COUNT(*) AS skill_count
    FROM skills_job_dim
    GROUP BY skill_id
)
SELECT
    sc.skills,
    sc.skill_id,
    sjd.skill_count
FROM skill_counts AS sjd
JOIN skills_dim AS sc
    ON sc.skill_id = sjd.skill_id
ORDER BY sjd.skill_count DESC

WITH skill_total AS (
    SELECT
        skill_id,
        COUNT(*) AS total_count
    FROM skills_job_dim
    GROUP BY skill_id   
)

SELECT
    sd.skills,
    skill_total.total_count
FROM skill_total
JOIN skills_dim AS sd
    ON sd.skill_id = skill_total.skill_id
ORDER BY skill_total.total_count DESC 