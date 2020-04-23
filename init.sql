CREATE TABLE "price_history" (
  "id"            INT       NOT NULL,
  "amount"        MONEY     NOT NULL,
  "validity"      TSRANGE   NOT NULL
);

CREATE TABLE "product_history" (
  "id"        INT       NOT NULL,
  "price_id"  INT       NOT NULL,
  "name"      TEXT      NOT NULL,
  "validity"  TSRANGE   NOT NULL
);

INSERT INTO "product_history" VALUES
  (1, 1, 'Apple',        '[2020-01-02 00:00, 2020-01-10 00:00)'),
  (1, 1, 'Green Apple',  '[2020-01-10 00:00, infinity)'),
  (2, 1, 'Ornage',       '[2020-01-20 00:00, 2020-01-23 00:00)'),
  (2, 1, 'Orange',       '[2020-01-23 00:00, 2020-01-29 00:00)'),
  (2, 1, 'Blood Orange', '[2020-01-29 00:00, infinity)');

INSERT INTO "price_history" VALUES
  (1, 20.00, '[2020-01-01 00:00, 2020-01-15 00:00)'),
  (1, 10.00, '[2020-01-15 00:00, 2020-01-25 00:00)'),
  (1, 20.00, '[2020-01-25 00:00, infinity)');
