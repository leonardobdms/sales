# frozen_string_literal: true

class HomeController < InertiaController
  def index
    @orders = Order.all
  end
end
