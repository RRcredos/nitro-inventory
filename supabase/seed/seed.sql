INSERT INTO public.businesses (id, name)
VALUES ('00000000-0000-0000-0000-0000000b0551', 'Default Business')
ON CONFLICT (id) DO NOTHING;

INSERT INTO auth.users (
  id,
  instance_id,
  email,
  encrypted_password,
  email_confirmed_at,
  created_at,
  updated_at,
  raw_app_meta_data,
  raw_user_meta_data,
  aud,
  role,
  confirmation_token,
  recovery_token,
  email_change_token_new,
  email_change
) VALUES
  (
    'a0000000-0000-0000-0000-000000000001',
    '00000000-0000-0000-0000-000000000000',
    'admin@bosspos.dev',
    crypt('password123!', gen_salt('bf')),
    now(),
    now(),
    now(),
    '{"provider": "email", "providers": ["email"], "role": "admin"}'::jsonb,
    '{"name": "Boss Admin"}'::jsonb,
    'authenticated',
    'authenticated',
    '',
    '',
    '',
    ''
  ),
  (
    'c0000000-0000-0000-0000-000000000001',
    '00000000-0000-0000-0000-000000000000',
    'cashier1@bosspos.dev',
    crypt('password123!', gen_salt('bf')),
    now(),
    now(),
    now(),
    '{"provider": "email", "providers": ["email"], "role": "cashier"}'::jsonb,
    '{"name": "Maria Santos"}'::jsonb,
    'authenticated',
    'authenticated',
    '',
    '',
    '',
    ''
  ),
  (
    'c0000000-0000-0000-0000-000000000002',
    '00000000-0000-0000-0000-000000000000',
    'cashier2@bosspos.dev',
    crypt('password123!', gen_salt('bf')),
    now(),
    now(),
    now(),
    '{"provider": "email", "providers": ["email"], "role": "cashier"}'::jsonb,
    '{"name": "Juan Cruz"}'::jsonb,
    'authenticated',
    'authenticated',
    '',
    '',
    '',
    ''
  )
ON CONFLICT (id) DO NOTHING;

INSERT INTO auth.identities (
  id,
  user_id,
  provider_id,
  identity_data,
  provider,
  last_sign_in_at,
  created_at,
  updated_at
)
SELECT
  id,
  id,
  id::text,
  format('{"sub": "%s", "email": "%s", "email_verified": true}', id::text, email)::jsonb,
  'email',
  now(),
  now(),
  now()
FROM auth.users
WHERE email IN ('admin@bosspos.dev', 'cashier1@bosspos.dev', 'cashier2@bosspos.dev')
ON CONFLICT (provider, provider_id) DO NOTHING;

INSERT INTO public.profiles (id, role, name, active) VALUES
  ('a0000000-0000-0000-0000-000000000001', 'admin', 'Boss Admin', true),
  ('c0000000-0000-0000-0000-000000000001', 'cashier', 'Maria Santos', true),
  ('c0000000-0000-0000-0000-000000000002', 'cashier', 'Juan Cruz', true)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.products (id, name, sku, price, stock_quantity, low_stock_threshold, category) VALUES
  ('b0000000-0000-0000-0000-000000000001', 'Coca-Cola 330ml',     'SKU-001', 45.00, 120, 20, 'Beverages'),
  ('b0000000-0000-0000-0000-000000000002', 'Pepsi 330ml',         'SKU-002', 45.00,  85, 20, 'Beverages'),
  ('b0000000-0000-0000-0000-000000000003', 'Bottled Water 500ml', 'SKU-003', 25.00, 200, 30, 'Beverages'),
  ('b0000000-0000-0000-0000-000000000004', 'Sky Flakes Crackers', 'SKU-004', 15.00,  60, 15, 'Snacks'),
  ('b0000000-0000-0000-0000-000000000005', 'Piattos Cheese',      'SKU-005', 30.00,  45, 15, 'Snacks'),
  ('b0000000-0000-0000-0000-000000000006', 'Nova Multigrain',     'SKU-006', 30.00,  40, 15, 'Snacks'),
  ('b0000000-0000-0000-0000-000000000007', 'Lucky Me Pancit',     'SKU-007', 18.00, 150, 25, 'Instant Food'),
  ('b0000000-0000-0000-0000-000000000008', 'Knorr Sinigang Mix',  'SKU-008', 12.00,  75, 20, 'Condiments'),
  ('b0000000-0000-0000-0000-000000000009', 'Mama Sita Adobo Mix', 'SKU-009', 12.00,  55, 20, 'Condiments'),
  ('b0000000-0000-0000-0000-00000000000a', 'Silver Swan Soy',     'SKU-010', 35.00,  30, 15, 'Condiments'),
  ('b0000000-0000-0000-0000-00000000000b', 'Colgate 100g',        'SKU-011', 55.00,  25, 10, 'Personal Care'),
  ('b0000000-0000-0000-0000-00000000000c', 'Safeguard Soap',      'SKU-012', 40.00,  18, 10, 'Personal Care'),
  ('b0000000-0000-0000-0000-00000000000d', 'Ligo Sardines',       'SKU-013', 28.00,   3,  8, 'Canned Goods'),
  ('b0000000-0000-0000-0000-00000000000e', 'Century Tuna',        'SKU-014', 45.00,   4,  8, 'Canned Goods'),
  ('b0000000-0000-0000-0000-00000000000f', 'Del Monte Ketchup',   'SKU-015', 55.00,   2, 10, 'Condiments')
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.customers (id, name, contact_number) VALUES
  ('c0000000-0000-0000-0001-000000000001', 'Ana Reyes', '09171234567'),
  ('c0000000-0000-0000-0001-000000000002', 'Pedro Lim', '09281234567'),
  ('c0000000-0000-0000-0001-000000000003', 'Rosa Dela Cruz', NULL)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.cash_sessions (id, cashier_id, status) VALUES
  (
    'c0000000-0000-0000-0002-000000000001',
    'c0000000-0000-0000-0000-000000000001',
    'open'
  )
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.transactions (
  id,
  cashier_id,
  session_id,
  customer_id,
  total,
  discount_amount,
  payment_method,
  change_given,
  status
) VALUES
  (
    'c0000000-0000-0000-0003-000000000001',
    'c0000000-0000-0000-0000-000000000001',
    'c0000000-0000-0000-0002-000000000001',
    'c0000000-0000-0000-0001-000000000001',
    120.00,
    0.00,
    'cash',
    30.00,
    'completed'
  ),
  (
    'c0000000-0000-0000-0003-000000000002',
    'c0000000-0000-0000-0000-000000000001',
    'c0000000-0000-0000-0002-000000000001',
    NULL,
    75.00,
    0.00,
    'cash',
    25.00,
    'completed'
  ),
  (
    'c0000000-0000-0000-0003-000000000003',
    'c0000000-0000-0000-0000-000000000001',
    'c0000000-0000-0000-0002-000000000001',
    'c0000000-0000-0000-0001-000000000002',
    90.00,
    5.00,
    'cash',
    10.00,
    'completed'
  ),
  (
    'c0000000-0000-0000-0003-000000000004',
    'c0000000-0000-0000-0000-000000000001',
    'c0000000-0000-0000-0002-000000000001',
    'c0000000-0000-0000-0001-000000000003',
    150.00,
    0.00,
    'online',
    0.00,
    'completed'
  ),
  (
    'c0000000-0000-0000-0003-000000000005',
    'c0000000-0000-0000-0000-000000000001',
    'c0000000-0000-0000-0002-000000000001',
    NULL,
    60.00,
    0.00,
    'cash',
    0.00,
    'voided'
  )
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.transaction_items (transaction_id, product_id, quantity, unit_price, subtotal) VALUES
  (
    'c0000000-0000-0000-0003-000000000001',
    'b0000000-0000-0000-0000-000000000001',
    2, 45.00, 90.00
  ),
  (
    'c0000000-0000-0000-0003-000000000001',
    'b0000000-0000-0000-0000-000000000004',
    2, 15.00, 30.00
  ),
  (
    'c0000000-0000-0000-0003-000000000002',
    'b0000000-0000-0000-0000-000000000003',
    3, 25.00, 75.00
  ),
  (
    'c0000000-0000-0000-0003-000000000003',
    'b0000000-0000-0000-0000-00000000000b',
    1, 55.00, 50.00
  ),
  (
    'c0000000-0000-0000-0003-000000000003',
    'b0000000-0000-0000-0000-00000000000c',
    1, 40.00, 40.00
  ),
  (
    'c0000000-0000-0000-0003-000000000004',
    'b0000000-0000-0000-0000-000000000002',
    2, 45.00, 90.00
  ),
  (
    'c0000000-0000-0000-0003-000000000004',
    'b0000000-0000-0000-0000-000000000006',
    2, 30.00, 60.00
  );

INSERT INTO public.attendance (employee_id, clock_in_at, clock_out_at, status) VALUES
  (
    'c0000000-0000-0000-0000-000000000001',
    now() - interval '3 hours',
    NULL,
    'open'
  ),
  (
    'c0000000-0000-0000-0000-000000000002',
    now() - interval '1 day',
    NULL,
    'flagged'
  );
