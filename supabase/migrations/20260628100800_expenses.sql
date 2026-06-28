CREATE TABLE IF NOT EXISTS public.expenses (
  id          UUID           PRIMARY KEY DEFAULT gen_random_uuid(),
  session_id  UUID           NOT NULL REFERENCES public.cash_sessions(id),
  cashier_id  UUID           NOT NULL REFERENCES public.profiles(id),
  amount      NUMERIC(10, 2) NOT NULL CHECK (amount > 0),
  description TEXT           NOT NULL,
  created_at  TIMESTAMPTZ    NOT NULL DEFAULT now()
);
