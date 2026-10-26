-- Contact-form messages for the bakery landing page.
-- Run once in Supabase Dashboard → SQL Editor.

create table if not exists public.messages (
  id         uuid primary key default gen_random_uuid(),
  name       text not null check (char_length(btrim(name)) between 1 and 100),
  phone      text not null check (phone ~ '^01[0125][0-9]{8}$'),
  message    text not null check (char_length(btrim(message)) between 1 and 2000),
  created_at timestamptz not null default now()
);

alter table public.messages enable row level security;

-- The page may only add rows, and only these three columns
-- (so a visitor can't fake created_at). No select, update or delete.
revoke all on public.messages from anon, authenticated;
grant insert (name, phone, message) on public.messages to anon;

drop policy if exists "Visitors can send a message" on public.messages;
create policy "Visitors can send a message"
  on public.messages
  for insert
  to anon
  with check (true);
