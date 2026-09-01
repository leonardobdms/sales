<script setup lang="ts">
import { Badge } from "@/components/ui/badge"
import { Button } from "@/components/ui/button"
import {
  Card,
  CardAction,
  CardContent,
  CardDescription,
  CardFooter,
  CardHeader,
  CardTitle,
} from "@/components/ui/card"
import type { Order } from "@/types"

import { formatStatus, orderActions, orderStatusVariant } from "."

defineProps<{ order: Order }>()

function formatTotal(cents: number) {
  return (cents / 100).toLocaleString("pt-BR", {
    style: "currency",
    currency: "BRL",
  })
}
</script>

<template>
  <Card class="gap-4 py-4">
    <CardHeader class="px-4">
      <CardTitle class="truncate">{{ order.customer_name }}</CardTitle>
      <CardDescription class="line-clamp-2">
        {{ order.address }}
      </CardDescription>
      <CardAction>
        <Badge class="capitalize" :variant="orderStatusVariant[order.status]">
          {{ formatStatus(order.status) }}
        </Badge>
      </CardAction>
    </CardHeader>
    <CardContent class="px-4 font-mono text-lg">
      {{ formatTotal(order.total_cents) }}
    </CardContent>
    <CardFooter v-if="orderActions[order.status]?.length" class="gap-2 px-4">
      <Button
        v-for="action in orderActions[order.status]"
        :key="action.label"
        type="button"
        size="sm"
        :variant="action.variant"
      >
        {{ action.label }}
      </Button>
    </CardFooter>
  </Card>
</template>
