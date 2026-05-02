-- 2. Нормалізація до 3НФ
-- Аналіз: атрибути Entity та Code повторюються у кожному рядку.
-- Рішення: винесемо їх у окрему таблицю-довідник `entities`,
-- а у фактовій таблиці залишимо лише посилання `entity_id`.

-- 2.1. Довідник унікальних сутностей (країна/регіон + ISO-код)
DROP TABLE IF EXISTS entities;
CREATE TABLE entities (
	   id     INT AUTO_INCREMENT PRIMARY KEY,
	   entity VARCHAR(150) NOT NULL,
       code   VARCHAR(10) NULL,
       UNIQUE KEY uq_entity_code (entity, code)
);
 
-- 2.2. Заповнюємо довідник унікальними значеннями
INSERT INTO entities (entity, code)
    SELECT DISTINCT Entity, nullif(trim(Code), '')
      FROM infectious_cases
;
 
-- 2.3. Нормалізована таблиця спостережень
DROP TABLE IF EXISTS infectious_cases_norm;
CREATE TABLE infectious_cases_norm (
       id                    INT AUTO_INCREMENT PRIMARY KEY,
       entity_id             INT NOT NULL,
       Year                  INT NOT NULL,
       Number_yaws           VARCHAR(50),
       polio_cases           VARCHAR(50),
       cases_guinea_worm     VARCHAR(50),
       Number_rabies         VARCHAR(50),
       Number_malaria        VARCHAR(50),
       Number_hiv            VARCHAR(50),
       Number_tuberculosis   VARCHAR(50),
       Number_smallpox       VARCHAR(50),
       Number_cholera_cases  VARCHAR(50),
       CONSTRAINT fk_icn_entity FOREIGN KEY (entity_id) REFERENCES entities(id),
       UNIQUE KEY uq_entity_year (entity_id, Year)
);
 
-- 2.4. Переносимо дані з оригінальної таблиці у нормалізовану
INSERT INTO infectious_cases_norm (
	   entity_id, Year, Number_yaws, polio_cases, cases_guinea_worm,
       Number_rabies, Number_malaria, Number_hiv, Number_tuberculosis,
       Number_smallpox, Number_cholera_cases)
    SELECT e.id,
           ic.Year,
           ic.Number_yaws,
           ic.polio_cases,
           ic.cases_guinea_worm,
           ic.Number_rabies,
           ic.Number_malaria,
           ic.Number_hiv,
           ic.Number_tuberculosis,
           ic.Number_smallpox,
           ic.Number_cholera_cases
      FROM infectious_cases ic
	  JOIN entities e ON e.entity = ic.Entity
                      AND ( (e.code = nullif(trim(ic.Code), ''))
                       OR   (e.code IS NULL AND nullif(trim(ic.Code), '') IS NULL) )
;
 
-- 2.5. Контрольні перевірки нормалізації
SELECT count(*) entities_cnt        FROM entities;
SELECT count(*) normalized_rows_cnt FROM infectious_cases_norm;
 