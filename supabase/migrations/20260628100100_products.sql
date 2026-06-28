CREATE TABLE If NOT EXISTS public.products (
  id                  UUID           PRIMARY KEY DEFAULT gen_random_uuid(),
  name                TEXT           NOT NULL,
  sku                 TEXT           NOT NULL UNIQUE,
  price               NUMERIC(10, 2) NOT NULL CHECK (price >= 0),
  stock_quantity      INTEGER        NOT NULL DEFAULT 0 CHECK (stock_quantity >= 0),
  low_stock_threshold INTEGER        NOT NULL DEFAULT 5,
  category            TEXT,
  active              BOOLEAN        NOT NULL DEFAULT true,
  created_at          TIMESTAMPTZ    NOT NULL DEFAULT now(),
  updated_at          TIMESTAMPTZ    NOT NULL DEFAULT now()
);

