# frozen_string_literal: true

class HomeIndexSerializer < ApplicationSerializer
  has_many :orders, resource: OrderSerializer
end
