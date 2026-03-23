create table if not exists public.resource_allocation_tasks (
  task_id uuid primary key default gen_random_uuid(),
  hospital_id text references public.hospitals(hospital_id),
  ward_number integer references public.wards(ward_id),
  task_type text not null check (task_type in ('redistribution', 'review')),
  status text not null check (status in ('open', 'under_review', 'resolved')),
  message text not null,
  assigned_official_id text references public.smc_officials(official_id),
  created_by uuid references public.auth_users(id),
  created_at timestamp without time zone default now()
);
