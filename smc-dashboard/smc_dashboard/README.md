# SAMVED SMC Administrative Portal

Administrative health-governance dashboard for the Solapur Municipal Corporation SAMVED ecosystem.

## Overview

This project is a Next.js 16 application for municipal health operations. It uses Supabase for authentication and database access, renders an authenticated multi-page admin portal, and includes API routes for outbreak detection, compliance reminders, alerts, notifications, complaint resolution, hospital verification, campaigns, and resource allocation workflows.

The root route redirects authenticated officials to `/dashboard` and unauthenticated users to `/login`.

## Stack

- Next.js 16.2.0
- React 19.2.4
- TypeScript
- Tailwind CSS 4
- Supabase SSR + Supabase JS
- TanStack React Query
- TanStack Table
- Recharts
- jsPDF / jsPDF Autotable
- date-fns
- Zod

## Main Portal Modules

- Dashboard
- Ward Health Index
- Disease Surveillance
- Hospitals
- Hospital Infrastructure
- Citizen Complaints
- Vaccination Campaigns
- Emergency Response
- Citizen Alerts
- Resource Allocation
- Health Card Administration
- Reports & Analytics
- System Monitoring
- Data Compliance
- Ward Risk Map
- Settings

## Authentication And Access

- Supabase Auth session handling is wired through middleware and server/browser clients.
- The app resolves the signed-in official from `auth_users` and `smc_officials`.
- Implemented role normalization maps users into:
  - `SMC Admin`
  - `SMC Health Officer`
  - `Ward Officer`
- Portal routes require authentication through `requireUserContext()`.

## Data Sources And Project Assets

- Application queries are centralized in `src/lib/data/queries.ts`.
- Database helper SQL files are stored in `database/`.
- The repository includes `supabase_database_schema_SAMVED_health_Ecosystem.txt` as a schema reference.
- `Samved_essential_data/solapur_maps.geojson` is used for the ward risk map flow.

## Environment Variables

Create `.env.local` with the variables used by the app:

```env
NEXT_PUBLIC_SUPABASE_URL=your_supabase_project_url
NEXT_PUBLIC_SUPABASE_PUBLISHABLE_KEY=your_supabase_publishable_key
GEMINI_API_KEY=your_gemini_api_key
OUTBREAK_CRON_SECRET=your_long_random_secret
```

Notes:

- `NEXT_PUBLIC_SUPABASE_URL` and `NEXT_PUBLIC_SUPABASE_PUBLISHABLE_KEY` are required for login and data access.
- `GEMINI_API_KEY` is optional. When present, the outbreak workflow generates short AI summaries and citizen-facing alert rewrites.
- `OUTBREAK_CRON_SECRET` is used by `POST /api/outbreak-detection` for cron-triggered runs when no authenticated user session is present.

## Scripts

```bash
npm run dev
npm run build
npm run start
npm run lint
```

The development script currently runs `next dev --webpack`.

## Local Development

```bash
npm install
npm run dev
```

Open [http://localhost:3000](http://localhost:3000).

## API Surface

Implemented API routes under `src/app/api` include:

- `/api/outbreak-detection`
- `/api/outbreak-alerts`
- `/api/compliance-alerts`
- `/api/resource-allocation`
- `/api/resource-allocation/tasks/[taskId]`
- `/api/alerts`
- `/api/campaigns`
- `/api/notifications`
- `/api/complaints/[id]/resolve`
- `/api/hospitals/[id]/verify`

## Project Structure

```text
src/
  app/                  App Router pages and API routes
  components/           Charts, forms, layout, tables, maps, providers
  lib/
    ai/                 Gemini outbreak text generation
    auth/               session and role utilities
    data/               dashboard/query aggregation
    disease-surveillance/
    supabase/           SSR/browser/middleware clients
    types/
database/               SQL helpers for operational workflows
public/                 static assets
Samved_essential_data/  map and reference assets
```

## Operational Notes

- Disease surveillance is computed from `disease_cases`, `wards`, and related joins, then scored by local outbreak detection logic in `src/lib/disease-surveillance/detection.ts`.
- Resource allocation can create internal tasks or fall back to notifications if the task table write fails.
- Data compliance status is derived from the age of hospital operational updates.
- Reports and analytics support CSV/PDF export from the portal UI.

## Verification

No automated test suite is configured in `package.json` at the moment. The available project checks are `npm run lint` and `npm run build`.
