CREATE TABLE IF NOT EXISTS public.attendance (
  id                UUID        PRIMARY KEY DEFAULT gen_random_uuid(),
  employee_id       UUID        NOT NULL REFERENCES public.profiles(id),
  clock_in_at       TIMESTAMPTZ NOT NULL DEFAULT now(),
  clock_out_at      TIMESTAMPTZ,
  device_identifier TEXT,
  status            TEXT        NOT NULL DEFAULT 'open' CHECK (status IN ('open', 'closed', 'flagged'))
);
