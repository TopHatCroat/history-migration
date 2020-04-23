DROP TABLE IF EXISTS "product_v2_history";

CREATE TABLE "product_v2_history" (
  "id"        INT       NOT NULL,
  "name"      TEXT      NOT NULL,
  "price"     MONEY     NOT NULL,
  "validity"  TSRANGE   NOT NULL
);

INSERT INTO product_v2_history
SELECT
  product_history.id,
  product_history.name,
  price_history.amount,
  TSRANGE(
    GREATEST(LOWER(product_history.validity), LOWER(price_history.validity)),
    CASE
      WHEN UPPER(price_history.validity) = 'infinity' THEN UPPER(product_history.validity)
      WHEN UPPER(product_history.validity) = 'infinity' THEN UPPER(price_history.validity)
      ELSE LEAST(UPPER(product_history.validity), UPPER(price_history.validity))
    END
  )
  FROM product_history
  FULL JOIN price_history
    ON product_history.price_id = price_history.id AND product_history.validity && price_history.validity
  ORDER BY product_history.validity;

-- EXPECTED RESULT
-- id       name            price       validity
-- 1        "Apple"         "20.00"     [2020-01-02 00:00, 2020-01-10 00:00)
-- 1        "Green Apple"   "20.00"     [2020-01-10 00:00, 2020-01-15 00:00)
-- 1        "Green Apple"   "10.00"     [2020-01-15 00:00, 2020-01-25 00:00)
-- 1        "Green Apple"   "20.00"     [2020-01-25 00:00, infinity)
-- 2        "Ornage"        "10.00"     [2020-01-20 00:00, 2020-01-23 00:00)
-- 2        "Orange"        "10.00"     [2020-01-23 00:00, 2020-01-25 00:00]
-- 2        "Orange"        "20.00"     [2020-01-25 00:00, 2020-01-29 00:00]
-- 2        "Blood Orange"  "20.00"     [2020-01-29 00:00, infinity]