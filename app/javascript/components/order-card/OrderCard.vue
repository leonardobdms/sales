<script setup lang="ts">
import { Form } from "@inertiajs/vue3"

import { Badge } from "@/components/ui/badge"
import { Button, type ButtonVariants } from "@/components/ui/button"
import {
  Card,
  CardAction,
  CardContent,
  CardDescription,
  CardFooter,
  CardHeader,
  CardTitle,
} from "@/components/ui/card"
import { order as orderPath } from "@/routes"
import type { Order } from "@/types"

import { formatStatus, orderStatusVariant } from "."

defineProps<{ order: Order }>()

function formatTotal(cents: number) {
  return (cents / 100).toLocaleString("pt-BR", {
    style: "currency",
    currency: "BRL",
  })
}

function buttonVariant(variant: string): ButtonVariants["variant"] {
  return variant === "destructive" ? "destructive" : "default"
}
</script>

<template>
  <Card class="gap-4 py-4">
    <CardHeader class="px-4">
      <CardTitle class="flex min-w-0 items-center gap-2">
        <span class="font-mono text-muted-foreground shrink-0">#{{ order.id }}</span>
        <span class="truncate">{{ order.customer_name }}</span>
      </CardTitle>
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
    <CardFooter v-if="order.actions.length" class="gap-2 px-4">
      <Form
        v-for="action in order.actions"
        :key="action.event"
        :action="orderPath(order.id)"
        :options="{ preserveScroll: true }"
        disable-while-processing
      >
        <input type="hidden" name="_token" :value="$page.props.csrf_token">
        <input type="hidden" name="event" :value="action.event" />
        <Button type="submit" size="sm" :variant="buttonVariant(action.variant)">
          {{ action.label }}
        </Button>
      </Form>
    </CardFooter>
  </Card>
</template>
