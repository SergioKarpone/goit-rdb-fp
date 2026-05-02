-- 5. Власна функція year_diff_from_now()

USE pandemic;

-- Якщо ввімкнено перевірку binlog, спочатку дозволяємо створення функцій:
SET GLOBAL log_bin_trust_function_creators = 1;
 
DROP FUNCTION IF EXISTS year_diff_from_now;
 
DELIMITER $$
CREATE FUNCTION year_diff_from_now(input_year INT)
       RETURNS INT
       DETERMINISTIC
       READS SQL DATA
BEGIN
    DECLARE result INT;
    SET result = TIMESTAMPDIFF(YEAR, MAKEDATE(input_year, 1), CURDATE());
    RETURN result;
END $$
DELIMITER ;
 
-- 5.1. Швидка перевірка функції
    SELECT year_diff_from_now(1996)            test_1996,
           year_diff_from_now(2010)            test_2010,
           year_diff_from_now(year(curdate())) test_current;
 
-- 5.2. Застосування функції на даних
    SELECT e.entity,
           e.code,
           icn.Year,
           year_diff_from_now(icn.Year) years_passed
      FROM infectious_cases_norm icn
      JOIN entities e ON e.id = icn.entity_id
  ORDER BY e.entity, icn.Year
     LIMIT 20
;