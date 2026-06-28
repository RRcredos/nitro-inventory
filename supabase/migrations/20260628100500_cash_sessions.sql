CREATE TABLE IF NOT EXISTS public.cash_sessions (
  id          UUID        PRIMARY KEY DEFAULT gen_random_uuid(),
  cashier_id  UUID        NOT NULL REFERENCES public.profiles(id),
  opened_at   TIMESTAMPTZ NOT NULL DEFAULT now(),
  closed_at   TIMESTAMPTZ,
  status      TEXT        NOT NULL DEFAULT 'open' CHECK (status IN ('open', 'closed', 'flagged')),
  created_at  TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at  TIMESTAMPTZ NOT NULL DEFAULT now()
);