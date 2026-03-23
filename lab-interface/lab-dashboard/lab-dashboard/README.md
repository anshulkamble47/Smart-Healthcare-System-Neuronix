# Lab Dashboard

This repository contains a frontend dashboard for SAMVED-linked laboratory operations. The runnable app lives in the nested `lab-dashboard/` folder and is built with React, Vite, Tailwind CSS, React Router, and Supabase.

The dashboard is wired to the SAMVED health ecosystem schema included in `supabase_database_schema_SAMVED_health_Ecosystem.txt`. It reads provider, appointment, report, catalog, notification, ward, citizen, and disease surveillance data from Supabase and supports a small set of write operations from the UI.

## Project layout

- `lab-dashboard/`: main Vite application
- `supabase_database_schema_SAMVED_health_Ecosystem.txt`: reference schema used by the app
- `.env.example`: example environment variables at the repository root
- `__MACOSX/`: extracted archive metadata folder

## Features implemented

- Provider workspace selection with a lightweight local session flag in `localStorage`
- Dashboard overview with:
  - tests today
  - pending bookings
  - provider report totals
  - role and ward notifications
  - high-risk disease cases
- Test bookings view backed by the `appointments` table
- Sample flow view derived from appointment status plus report presence
- Report creation into `diagnostic_reports`
- Provider-specific test catalog from `lab_tests` joined with `test_types`
- Searchable test history for uploaded reports
- Disease surveillance summary built from `disease_cases`, `diseases`, and `citizens`
- Notification feed filtered by provider role and ward
- Settings page for provider profile updates and theme toggle

## Database tables used

The current app code reads from these tables:

- `provider`
- `wards`
- `appointments`
- `diagnostic_reports`
- `lab_tests`
- `test_types`
- `notifications`
- `disease_cases`
- `citizens`

The current app writes to these tables:

- `appointments` via status updates
- `diagnostic_reports` via new report creation
- `test_types` when a catalog test type does not already exist
- `lab_tests` via new provider catalog entries
- `provider` via settings/profile updates

## Environment variables

The Vite app expects these variables:

```env
VITE_SUPABASE_URL=your_supabase_project_url
VITE_SUPABASE_ANON_KEY=your_supabase_anon_or_publishable_key
VITE_PROVIDER_ID=
```

Backwards-compatible fallback names are also supported by the code:

```env
NEXT_PUBLIC_SUPABASE_URL=your_supabase_project_url
NEXT_PUBLIC_SUPABASE_PUBLISHABLE_KEY=your_supabase_anon_or_publishable_key
```

If the Supabase variables are missing, the app falls back to a local demo provider and shows a warning instead of loading live data.

## Getting started

From the repository root:

```bash
cd lab-dashboard
npm install
npm run dev
```

Build for production:

```bash
cd lab-dashboard
npm run build
```

Preview the production build:

```bash
cd lab-dashboard
npm run preview
```

## Tech stack

- React 18
- Vite 5
- React Router DOM 6
- Supabase JavaScript client 2
- Tailwind CSS 3
- PostCSS + Autoprefixer

## Notes and current limitations

- Authentication is not backed by Supabase Auth. Login state is simulated with `localStorage` using the `samved-session` key.
- Sample collection is inferred from appointment/report state because the provided schema does not include a dedicated sample-tracking table.
- The app scopes reports, catalog items, and notifications to the selected provider workspace where possible.
- There is no automated test suite configured in the current project.
- A production build output already exists under `lab-dashboard/dist/`.
