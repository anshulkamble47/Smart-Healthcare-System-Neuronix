import type { Metadata } from "next";
import { Public_Sans, JetBrains_Mono } from "next/font/google";

import "@/app/globals.css";
import { AppProviders } from "@/components/providers/app-providers";

const publicSans = Public_Sans({
  variable: "--font-public-sans",
  subsets: ["latin"],
});

const jetBrainsMono = JetBrains_Mono({
  variable: "--font-jetbrains-mono",
  subsets: ["latin"],
});

export const metadata: Metadata = {
  title: "SAMVED SMC Administrative Portal",
  description:
    "Government administrative control center for Solapur Municipal Corporation health governance.",
};

export default function RootLayout({
  children,
}: Readonly<{
  children: React.ReactNode;
}>) {
  return (
    <html
      lang="en"
      suppressHydrationWarning
      className={`${publicSans.variable} ${jetBrainsMono.variable}`}
    >
      <body>
        <AppProviders>{children}</AppProviders>
      </body>
    </html>
  );
}
