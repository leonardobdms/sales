# frozen_string_literal: true

class OrderEventPublisher
  class << self
    attr_accessor :enabled

    self.enabled = !Rails.env.test?

    def created(order)
      publish(
        event: "order.created",
        order: order,
        payload: {
          customer_name: order.customer_name,
          address: order.address,
          total_cents: order.total_cents,
          status: order.status
        }
      )
    end

    def confirmed(order)
      publish(
        event: "order.confirmed",
        order: order,
        payload: { address: order.address }
      )
    end

    def cancelled(order)
      publish(event: "order.cancelled", order: order)
    end

    private

    def publish(event:, order:, payload: {})
      return unless enabled

      Karafka.producer.produce_sync(
        topic: "sales.orders",
        key: order.id.to_s,
        payload: { event: event, id: order.id, **payload }.to_json
      )
    end
  end
end
