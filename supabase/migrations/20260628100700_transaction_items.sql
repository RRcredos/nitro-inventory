CREATE TABLE IF NOT EXISTS public.transaction_items (
  id              UUID           PRIMARY KEY DEFAULT gen_random_uuid(),
  transaction_id  UUID           NOT NULL REFERENCES public.transactions(id) ON DELETE CASCADE,
  product_id      UUID           NOT NULL REFERENCES public.products(id),
  quantity        INTEGER        NOT NULL CHECK (quantity > 0),
  unit_price      NUMERIC(10, 2) NOT NULL,
  subtotal        NUMERIC(10, 2) NOT NULL
);