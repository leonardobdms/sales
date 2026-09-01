import type { BadgeVariants } from "@/components/ui/badge"

export { default as OrderCard } from "./OrderCard.vue"

export function formatStatus(status: string) {
  return status.replaceAll("_", " ")
}

export const orderStatusVariant: Record<string, BadgeVariants["variant"]> = {
  pending: "pending",
  confirmed: "confirmed",
  preparing: "preparing",
  shipped: "shipped",
  delivered: "delivered",
  cancelled: "cancelled",
}
