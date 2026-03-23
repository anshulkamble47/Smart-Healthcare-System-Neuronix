-- Clear existing citizen-facing alerts and restrict future alert types.
-- Run this in Supabase SQL Editor.

delete from public.alerts;

alter table public.alerts
drop constraint if exists alerts_alert_type_allowed_values;

alter table public.alerts
add constraint alerts_alert_type_allowed_values
check (
  alert_type in (
    'Vaccination Campaign',
    'Health Advisory',
    'Vaccination Drive',
    'Hot Alerts'
  )
);
