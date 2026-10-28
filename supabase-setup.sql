-- Dharamshala Split: run this once in Supabase → SQL Editor → New query → Run.
-- Creates two small tables (prefixed ds_ so they don't touch your other projects' tables).

create table if not exists public.ds_expenses (
  id uuid primary key default gen_random_uuid(),
  created_at timestamptz not null default now(),
  kind text not null default 'expense' check (kind in ('expense', 'settle')),
  note text not null default 'Expense' check (char_length(note) <= 60),
  amount numeric(12,2) not null check (amount > 0 and amount < 10000000),
  payer smallint not null check (payer between 0 and 3),
  split boolean[] not null check (array_length(split, 1) = 4)
);

create table if not exists public.ds_settings (
  id int primary key default 1 check (id = 1),
  names text[] not null default array['Schoolboy', 'Bathroom guy', 'Andekha', 'Gridgossip'],
  budget numeric(12,2) not null default 0 check (budget >= 0 and budget < 100000000)
);
insert into public.ds_settings (id) values (1) on conflict (id) do nothing;

-- Anyone with the app link can read, add and delete expenses, and edit names/budget.
alter table public.ds_expenses enable row level security;
alter table public.ds_settings enable row level security;

drop policy if exists "ds_expenses read" on public.ds_expenses;
drop policy if exists "ds_expenses add" on public.ds_expenses;
drop policy if exists "ds_expenses delete" on public.ds_expenses;
drop policy if exists "ds_settings read" on public.ds_settings;
drop policy if exists "ds_settings edit" on public.ds_settings;

create policy "ds_expenses read"   on public.ds_expenses for select to anon, authenticated using (true);
create policy "ds_expenses add"    on public.ds_expenses for insert to anon, authenticated with check (true);
create policy "ds_expenses delete" on public.ds_expenses for delete to anon, authenticated using (true);
create policy "ds_settings read"   on public.ds_settings for select to anon, authenticated using (true);
create policy "ds_settings edit"   on public.ds_settings for update to anon, authenticated using (id = 1) with check (id = 1);

grant select, insert, delete on public.ds_expenses to anon, authenticated;
grant select, update on public.ds_settings to anon, authenticated;

-- Live updates between phones.
do $$ begin
  alter publication supabase_realtime add table public.ds_expenses;
exception when duplicate_object then null; end $$;
do $$ begin
  alter publication supabase_realtime add table public.ds_settings;
exception when duplicate_object then null; end $$;
