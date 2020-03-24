DROP TABLE IF EXISTS "product_v2_history";

CREATE TABLE "product_v2_history" (
    "id"        INT       NOT NULL,
    "name"      INT       NOT NULL,
    "price"     MONEY     NOT NULL,
    "validity"  TSRANGE   NOT NULL
)

do
$BODY$
    DECLARE
        _history_entry RECORD;
    BEGIN
        for _history_entry IN (
            SELECT product_history.id,
                    product_history.name,
                    product_history.validity,
                    price_history.amount,
                    price_history.validity
            FROM product_history
            JOIN price_history ON product_history.price_id = price_history.id AND product_history.validity && price_history.validity
            )
            LOOP
                INSERT INTO product_v2_history
                VALUES (
                    product_history.id,
                    product_history.name,
                    price.amount,
                    min
                ) 
                    
                where invoicing_account_history.price_rate_id = _current_price_rate_history.id
                  and _current_price_rate_history.validity && invoicing_account_history.validity;
            end loop;
    end;

$BODY$ language plpgsql;


-- EXPECTED RESULT
-- id       name        price       validity
-- 1        "Apple"     "20.00"     [2020-01-01 00:00, 2020-01-20 00:00)
-- 1        "Red Apple" "20.00"     [2020-01-20 00:00, 2020-01-25 00:00)
-- 1        "Red Apple" "10.00"     [2020-01-25 00:00, 2020-01-28 00:00)
-- 1        "Red Apple" "20.00"     [2020-01-28 00:00, infinity)
-- 1        "Orange"    "20.00"     [2020-01-29 00:00, infinity]