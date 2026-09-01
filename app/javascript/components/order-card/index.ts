import type { BadgeVariants } from "@/components/ui/badge"
import type { ButtonVariants } from "@/components/ui/button"

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

export type OrderAction = {
  label: string
  variant?: ButtonVariants["variant"]
}

export const orderActions: Record<string, OrderAction[]> = {
  pending: [{ label: "Confirm" }, { label: "Cancel", variant: "destructive" }],
  confirmed: [
    { label: "Prepare" },
    { label: "Cancel", variant: "destructive" },
  ],
  preparing: [{ label: "Ship" }, { label: "Cancel", variant: "destructive" }],
  shipped: [{ label: "Deliver" }],
  delivered: [],
  cancelled: [],
}
