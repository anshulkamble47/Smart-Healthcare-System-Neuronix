create table if not exists public.outbreak_signals (
  signal_id uuid primary key default gen_random_uuid(),
  ward_number integer not null references public.wards(ward_id),
  disease_id text not null references public.diseases(disease_id),
  disease_name text,
  current_week_cases integer not null default 0,
  previous_week_cases integer not null default 0,
  active_cases integer not null default 0,
  severe_cases integer not null default 0,
  positivity_rate double precision not null default 0,
  health_index double precision not null default 0,
  outbreak_score double precision not null default 0,
  risk_level text not null,
  ai_summary text,
  created_at timestamp without time zone default now(),
  updated_at timestamp without time zone default now()
);

create unique index if not exists outbreak_signals_ward_disease_key
on public.outbreak_signals (ward_number, disease_id);
