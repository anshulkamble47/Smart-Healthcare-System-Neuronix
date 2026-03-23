# Pharma Dashboard

This repository contains a React + Vite pharmacy operations dashboard. The actual application code lives in the nested [`PharmaDashboard`](C:\Users\ASUS\OneDrive\Desktop\PharmaDashboard\PharmaDashboard) folder.

The dashboard is built for pharmacy workflow monitoring and includes:

- Dashboard summary cards for inventory, low stock, pending prescriptions, alerts, and orders
- Inventory management with add, edit, and remove actions
- Prescription verification
- Order status workflow management
- Sales analytics
- Rare and critical stock tracking
- Demand signal monitoring
- Public health alerts
- Pharmacy profile settings
- Light and dark theme support
- Supabase-ready data access with a mock-data fallback

## Project Layout

```text
PharmaDashboard/
|-- README.md
|-- PharmaDashboard/
|   |-- src/
|   |-- dist/
|   |-- package.json
|   |-- .env.example
|   `-- vite.config.js
`-- __MACOSX/
```

## Tech Stack

- React 19
- React Router DOM 7
- Vite 8
- Plain CSS with custom design tokens

## Application Behavior

The app uses a shared data layer in [`src/lib/database.js`](C:\Users\ASUS\OneDrive\Desktop\PharmaDashboard\PharmaDashboard\src\lib\database.js).

- If `VITE_SUPABASE_URL` and `VITE_SUPABASE_ANON_KEY` are set, the app uses Supabase REST endpoints.
- If those values are missing, the app runs entirely from mock data in [`src/data/mockData.js`](C:\Users\ASUS\OneDrive\Desktop\PharmaDashboard\PharmaDashboard\src\data\mockData.js).
- Session state is stored in browser local storage under `pharma-dashboard-session`.

## Mock Login

Without Supabase configuration, the seeded login is:

- Email: `pharmacy@health.gov`
- Password: `password123`

## Supabase Environment Variables

Copy `.env.example` to `.env` inside the app folder and set the values:

```env
VITE_SUPABASE_URL=https://your-project-id.supabase.co
VITE_SUPABASE_ANON_KEY=your-anon-key
VITE_SUPABASE_PROVIDER_TABLE=provider
VITE_SUPABASE_MEDICINES_TABLE=medicines
VITE_SUPABASE_STOCK_TABLE=pharmacy_medicine_stock
VITE_SUPABASE_HEALTH_RECORDS_TABLE=health_records
VITE_SUPABASE_ALERTS_TABLE=alerts
VITE_SUPABASE_NOTIFICATIONS_TABLE=notifications
VITE_SUPABASE_ORDERS_TABLE=orders
VITE_SUPABASE_SALES_TABLE=sales_records
```

The code expects a provider row linked to the authenticated user by one of these fields:

- `provider_id`
- `auth_user_id`
- `user_id`
- `email`

## Getting Started

From the current folder:

```powershell
cd .\PharmaDashboard
npm install
npm run dev
```

The default Vite dev server will then be available locally, typically at [http://localhost:5173](http://localhost:5173).

## Available Scripts

Run these inside [`PharmaDashboard`](C:\Users\ASUS\OneDrive\Desktop\PharmaDashboard\PharmaDashboard):

- `npm run dev` - start the development server
- `npm run build` - create a production build in `dist/`
- `npm run preview` - preview the production build locally

## Main Routes

- `/login`
- `/`
- `/inventory`
- `/prescriptions`
- `/orders`
- `/sales`
- `/rare-medicines`
- `/demand`
- `/alerts`
- `/settings`

## Notes

- There is no test suite configured in `package.json` yet.
- `dist/` is already present, so the project has been built at least once.
- The `__MACOSX` folder appears to be leftover archive metadata and is not used by the app.
