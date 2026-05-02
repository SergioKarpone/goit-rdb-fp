-- 3. Аналіз Number_rabies (avg / min / max / sum), TOP-10

USE pandemic;

    SELECT e.entity,
           e.code,
           avg(cast(icn.Number_rabies AS DECIMAL(20,4))) avg_rabies,
           min(cast(icn.Number_rabies AS DECIMAL(20,4))) min_rabies,
           max(cast(icn.Number_rabies AS DECIMAL(20,4))) max_rabies,
           sum(cast(icn.Number_rabies AS DECIMAL(20,4))) sum_rabies
	  FROM infectious_cases_norm icn
	  JOIN entities e ON e.id = icn.entity_id
	 WHERE icn.Number_rabies IS NOT NULL
	   AND TRIM(icn.Number_rabies) <> ''
  GROUP BY e.entity, 
           e.code
  ORDER BY avg_rabies DESC
     LIMIT 10
; 