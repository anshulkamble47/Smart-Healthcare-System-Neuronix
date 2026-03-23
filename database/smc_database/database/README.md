# Database (Supabase)

This project uses **Supabase (PostgreSQL)** as the primary database to manage all healthcare-related data across citizens, hospitals, providers, and SMC officials.

---

## 🔹 Overview

The database is designed to support a **unified public health ecosystem**, enabling real-time data integration, secure access, and scalable data management.

It stores structured data for:
- Citizens and authentication
- Hospitals and staff
- Health records and disease cases
- Appointments and telemedicine sessions
- Lab reports and prescriptions
- Medicine inventory and infrastructure
- Health indicators and outbreak signals

---

## 🔹 Key Features

- Centralized database for all modules (Citizen, Hospital, Provider, SMC)
- Real-time data updates and synchronization
- Role-Based Access Control (RBAC)
- Secure storage of sensitive health data
- Support for analytics and Health Index computation

---

## 🔹 Core Tables

### 👤 User & Citizen Management
- `auth_users` – Stores authentication credentials and roles
- `citizens` – Citizen personal and demographic information

### 🏥 Hospital & Staff Management
- `hospitals` – Hospital details and location
- `hospital_staff` – Staff details with roles (doctor, admin, etc.)
- `doctors` – Doctor-specific attributes

### 📅 Appointments & Telemedicine
- `appointments` – Appointment booking and scheduling
- `telemedicine_sessions` – Online consultation sessions

### 🧾 Health Records & Reports
- `health_records` – Diagnosis, prescriptions, and visit details
- `diagnostic_reports` – Lab test reports and files
- `disease_cases` – Reported disease cases

### 💊 Medicines & Infrastructure
- `medicines` – Medicine details
- `hospital_medicine_stock` – Hospital inventory
- `pharmacy_medicine_stock` – Pharmacy stock
- `beds` – Bed allocation and status
- `medical_equipment` – Equipment tracking

### 📊 Analytics & Monitoring
- `health_indicator_data` – Raw indicator data
- `health_index_results` – Computed Health Index
- `outbreak_signals` – Disease trends and outbreak signals

### 🔔 Alerts & Notifications
- `alerts` – Public health alerts
- `notifications` – System and user notifications

### 🔁 Referrals & Complaints
- `referrals` – Inter-hospital patient transfers
- `complaints` – Citizen feedback and issues

---

## 🔹 Data Flow

- Citizen registers → data stored in `citizens`
- Hospital updates treatment → stored in `health_records`
- Lab uploads reports → stored in `diagnostic_reports`
- Disease cases recorded → stored in `disease_cases`
- Indicator data aggregated → processed into `health_index_results`
- SMC dashboard receives **only aggregated and anonymized data**

---

## 🔹 Security & Access Control

- Role-Based Access Control (RBAC) implemented
- Sensitive patient data accessible only to authorized hospital staff
- Foreign key constraints ensure data integrity
- Controlled access to reports and files

---

## 🔹 Notes

- Full schema is available in `schema.sql`
- Database is designed for scalability and real-time updates