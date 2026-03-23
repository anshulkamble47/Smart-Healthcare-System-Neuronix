import { Sidebar } from "@/components/layout/sidebar";
import { Topbar } from "@/components/layout/topbar";
import { requireUserContext } from "@/lib/auth/session";

export default async function PortalLayout({
  children,
}: {
  children: React.ReactNode;
}) {
  const user = await requireUserContext();

  return (
    <div className="page-shell flex">
      <Sidebar role={user.role} />
      <div className="min-w-0 flex-1">
        <Topbar user={user} />
        <main className="px-4 py-6 md:px-6">{children}</main>
      </div>
    </div>
  );
}
