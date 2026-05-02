-- 1. Створення схеми та імпорт даних

-- 1.1. Створюємо схему (за замовчуванням)
CREATE SCHEMA IF NOT EXISTS pandemic
       DEFAULT CHARACTER SET utf8mb4
       DEFAULT COLLATE utf8mb4_unicode_ci
;

-- 1.2. Перевірка кількості завантажених рядків
 
USE pandemic;

SELECT count(*) AS total_rows FROM infectious_cases;