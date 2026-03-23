import { SettingsWorkspace } from "@/components/settings/settings-workspace";
import { requireUserContext } from "@/lib/auth/session";

export default async function SettingsPage() {
  const user = await requireUserContext("/settings");

  return <SettingsWorkspace user={user} />;
}
