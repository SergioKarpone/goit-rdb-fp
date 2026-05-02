-- 4. Колонка різниці в роках (вбудовані SQL-функції)

USE pandemic;

    SELECT icn.entity_id,
           icn.Year,
           makedate(icn.Year, 1)                                 first_january,
           curdate()                                             today,
           timestampdiff(YEAR, makedate(icn.Year, 1), curdate()) year_diff
      FROM infectious_cases_norm icn
  ORDER BY icn.entity_id, icn.Year
     LIMIT 20
;