# Supabase Configuration & Usage

---

## 🔹 Why Supabase?

Supabase was chosen as the backend because it provides:

- PostgreSQL-based relational database
- Built-in APIs for fast integration
- Real-time data capabilities
- Scalable and cloud-managed infrastructure
- Secure storage and authentication support

---

## 🔹 Features Used

### 1. Database (PostgreSQL)
- Stores all structured application data
- Supports relationships using foreign keys
- Enables complex queries and analytics

---

### 2. Supabase Storage
- Used to store lab reports and medical files
- Secure file access using signed URLs
- Private buckets ensure data protection

---

### 3. Scheduled Queries (Cron Jobs)
- Used for **Health Index computation**
- Runs automated SQL queries at defined intervals
- Generates ward-level health indicators

---

### 4. API Integration
- Backend interacts with Supabase using `@supabase/supabase-js`
- Data fetched and updated via secure API calls

---

### 5. Role-Based Access Control (RBAC)
- Implemented at application level
- Ensures only authorized roles (doctor, admin, SMC) can access specific features

---

## 🔹 Data Security

- Sensitive health data is restricted to authorized users
- Aggregated data is shared with SMC for analytics
- Secure access to files via signed URLs

---

## 🔹 Scalability

- Supabase supports horizontal scaling
- Suitable for large-scale city-level healthcare data
- Efficient handling of concurrent users and real-time updates

---

## 🔹 Summary

Supabase enables a **secure, scalable, and real-time backend system** for the SAMVED healthcare platform, supporting both operational workflows and data-driven governance.