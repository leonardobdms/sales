# frozen_string_literal: true

class OrderSerializer < ApplicationSerializer
  typelize_from Order

  attributes :id, :customer_name, :status, :total_cents, :address
end
