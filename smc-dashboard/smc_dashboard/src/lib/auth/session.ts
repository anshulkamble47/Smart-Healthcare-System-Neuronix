import { redirect } from "next/navigation";

import { normalizeRole, canAccess } from "@/lib/auth/roles";
import { createClient } from "@/lib/supabase/server";
import type { UserContext } from "@/lib/types/schema";

export async function getCurrentUserContext(): Promise<UserContext | null> {
  if (
    !process.env.NEXT_PUBLIC_SUPABASE_URL ||
    !process.env.NEXT_PUBLIC_SUPABASE_PUBLISHABLE_KEY
  ) {
    return null;
  }

  const supabase = await createClient();
  const {
    data: { user },
  } = await supabase.auth.getUser();

  if (!user) {
    return null;
  }

  const [{ data: authUser }, { data: official }] = await Promise.all([
    supabase
      .from("auth_users")
      .select("id, email, role")
      .eq("id", user.id)
      .maybeSingle(),
    supabase
      .from("smc_officials")
      .select("official_id, name, designation, role")
      .eq("user_id", user.id)
      .maybeSingle(),
  ]);

  const role = normalizeRole(official?.role ?? authUser?.role);

  return {
    id: user.id,
    email: user.email ?? authUser?.email ?? null,
    role,
    officialId: official?.official_id ?? null,
    name: official?.name ?? user.email ?? "SMC Official",
    designation: official?.designation ?? null,
  };
}

export async function requireUserContext(pathname?: string) {
  const context = await getCurrentUserContext();

  if (!context) {
    redirect("/login");
  }

  if (pathname && !canAccess(context.role, pathname)) {
    redirect("/dashboard");
  }

  return context;
}
