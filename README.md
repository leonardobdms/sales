# Sales

App Rails de pedidos — parte do laboratório EDA. Gerencia `orders` e, no futuro, publica eventos de pedido no Kafka e consome atualizações de entrega.

## Stack

- Ruby 4.0 / Rails 8.1
- SQLite
- Inertia.js + Vue 3 + Vite + Tailwind
- Alba + Typelizer
- AASM (máquina de estados)
- Solid Cache / Queue / Cable

## Schema

Tabela `orders`:

| Coluna | Tipo | Notas |
|--------|------|-------|
| `customer_name` | string | NOT NULL, mín. 3 caracteres (doc) |
| `status` | string | default `pending` |
| `total_cents` | integer | default 0, > 0 (doc) |
| `address` | string | NOT NULL |

**Statuses:** `pending`, `confirmed`, `preparing`, `shipped`, `delivered`, `cancelled`

Diagrama: [db/diagram/sales.dbml](db/diagram/sales.dbml)

## Máquina de estados (AASM)

O model `Order` define transições explícitas. Exemplo no console:

```ruby
order = Order.create!(customer_name: "Maria", address: "Rua A, 1", total_cents: 5000)
order.confirm!           # pending → confirmed
order.start_preparing!   # confirmed → preparing
order.ship!              # preparing → shipped
order.deliver!           # shipped → delivered

order.cancel!            # só de pending, confirmed ou preparing
```

| Evento | De | Para |
|--------|----|------|
| `confirm` | `pending` | `confirmed` |
| `start_preparing` | `confirmed` | `preparing` |
| `ship` | `preparing` | `shipped` |
| `deliver` | `shipped` | `delivered` |
| `cancel` | `pending`, `confirmed`, `preparing` | `cancelled` |

No EDA, `deliver` também será disparado ao consumir `delivery.status_changed` com status `delivered`.

## Papel no EDA

- **Producer:** publica `order.created`, `order.confirmed`, `order.cancelled` no tópico `sales.orders`
- **Consumer:** escuta `delivery.status_changed` no tópico `deliveries.deliveries` e atualiza o status do pedido

> Kafka/Karafka ainda não estão implementados. Veja o [README da raiz](../README.md) para o contrato de eventos.

## Setup

```bash
bundle install
bin/rails db:setup   # migrate + seed
bin/dev            # http://localhost:3000
```

## Seeds

25 pedidos fictícios com Faker (locale pt-BR):

```bash
bin/rails db:seed
```

Gera `customer_name`, `address`, `total_cents` (R$ 10–500) e cicla pelos 6 statuses. Idempotente: apaga e recria os registros. Os statuses são atribuídos diretamente (bypass da máquina de estados) para variar os dados de demo.

## Testes

```bash
bin/rspec
```
