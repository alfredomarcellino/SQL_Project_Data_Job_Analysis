WITH count_skill AS (
    SELECT
        skill_id,
        COUNT(*) AS count_skill
    FROM    
         skills_job_dim AS sjd
    JOIN job_postings_fact AS jpf ON
    sjd.job_id = jpf.job_id
    WHERE jpf.job_location = 'Anywhere' AND jpf.job_title_short = 'Data Analyst'
    GROUP BY skill_id     
)

SELECT
    sd.skill_id,
    sd.skills,
    cs.count_skill
FROM    
    count_skill AS cs
LEFT JOIN skills_dim AS sd ON sd.skill_id = cs.skill_id
ORDER BY cs.count_skill DESC
LIMIT 5;
