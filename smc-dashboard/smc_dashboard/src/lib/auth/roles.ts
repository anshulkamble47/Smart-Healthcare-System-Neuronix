import type { OfficialRole } from "@/lib/types/schema";

export const ROLES: OfficialRole[] = [
  "SMC Admin",
  "SMC Health Officer",
  "Ward Officer",
];

export const sidebarItems = [
  { href: "/dashboard", label: "Dashboard" },
  { href: "/ward-health-index", label: "Ward Health Index" },
  { href: "/disease-surveillance", label: "Disease Surveillance" },
  { href: "/hospitals", label: "Hospitals" },
  { href: "/hospital-infrastructure", label: "Hospital Infrastructure" },
  { href: "/citizen-complaints", label: "Citizen Complaints" },
  { href: "/vaccination-campaigns", label: "Vaccination Campaigns" },
  { href: "/emergency-response", label: "Emergency Response" },
  { href: "/alerts-notifications", label: "Citizen Alerts" },
  { href: "/resource-allocation", label: "Resource Allocation" },
  { href: "/health-card-administration", label: "Health Card Administration" },
  { href: "/reports-analytics", label: "Reports & Analytics" },
  { href: "/system-monitoring", label: "System Monitoring" },
  { href: "/data-compliance", label: "Data Compliance" },
  { href: "/ward-risk-map", label: "Ward Risk Map" },
  { href: "/settings", label: "Settings" },
] as const;

const roleMatrix: Record<OfficialRole, string[]> = {
  "SMC Admin": sidebarItems.map((item) => item.href),
  "SMC Health Officer": sidebarItems.map((item) => item.href),
  "Ward Officer": sidebarItems.map((item) => item.href),
};

export function normalizeRole(value: string | null | undefined): OfficialRole {
  if (!value) {
    return "Ward Officer";
  }

  if (value.toLowerCase().includes("admin")) {
    return "SMC Admin";
  }

  if (value.toLowerCase().includes("health")) {
    return "SMC Health Officer";
  }

  return "Ward Officer";
}

export function canAccess(role: OfficialRole, pathname: string) {
  return roleMatrix[role].includes(pathname);
}
