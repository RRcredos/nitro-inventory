CREATE TABLE IF NOT EXISTS public.transactions (
  id              UUID           PRIMARY KEY DEFAULT gen_random_uuid(),
  cashier_id      UUID           NOT NULL REFERENCES public.profiles(id),
  session_id      UUID           NOT NULL REFERENCES public.cash_sessions(id),
  customer_id     UUID           REFERENCES public.customers(id),
  total           NUMERIC(10, 2) NOT NULL CHECK (total >= 0),
  discount_amount NUMERIC(10, 2) NOT NULL DEFAULT 0,
  payment_method  TEXT           NOT NULL DEFAULT 'cash',
  change_given    NUMERIC(10, 2) NOT NULL DEFAULT 0,
  status          TEXT           NOT NULL DEFAULT 'completed' CHECK (status IN ('completed', 'voided')),
  created_at      TIMESTAMPTZ    NOT NULL DEFAULT now()
);
