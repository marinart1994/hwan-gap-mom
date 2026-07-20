create table if not exists public.guestbook_entries (
  id uuid primary key default gen_random_uuid(),
  name text,
  body text not null,
  created_at timestamptz not null default now()
);

alter table public.guestbook_entries enable row level security;

drop policy if exists "Anyone can read guestbook entries" on public.guestbook_entries;
create policy "Anyone can read guestbook entries"
on public.guestbook_entries
for select
to anon
using (true);

drop policy if exists "Anyone can write guestbook entries" on public.guestbook_entries;
create policy "Anyone can write guestbook entries"
on public.guestbook_entries
for insert
to anon
with check (
  body is not null
  and length(trim(body)) between 1 and 2000
  and (name is null or length(trim(name)) <= 80)
);
