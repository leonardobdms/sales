<script setup lang="ts">
import { Head } from "@inertiajs/vue3"

import { OrderCard } from "@/components/order-card"
import type { HomeIndex } from "@/types"

const { orders } = defineProps<HomeIndex>()
</script>

<template>
  <Head title="Sales" />
  <div class="mx-auto flex min-h-dvh max-w-[1400px] flex-col gap-6 p-6 md:p-8">
    <h1 class="text-2xl font-semibold tracking-tight">Orders</h1>
    <p v-if="!orders.length" class="text-muted-foreground text-sm">
      No orders yet.
    </p>
    <div v-else class="grid grid-cols-1 gap-4 md:grid-cols-2 lg:grid-cols-3">
      <OrderCard v-for="order in orders" :key="order.id" :order="order" />
    </div>
  </div>
</template>
