import { redirect } from "next/navigation";

import { getCurrentUserContext } from "@/lib/auth/session";

export default async function HomePage() {
  const context = await getCurrentUserContext();
  redirect(context ? "/dashboard" : "/login");
}
