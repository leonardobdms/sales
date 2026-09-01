# frozen_string_literal: true

class OrdersController < InertiaController
  rescue_from ActiveRecord::RecordNotFound, with: :not_found

  def update
    event = params[:event].to_s.to_sym

    unless order.aasm.may_fire_event?(event)
      redirect_back_or_to root_path, alert: "Invalid status transition"
      return
    end

    order.aasm.fire!(event)
    redirect_to root_path
  end

  private

  def order
    @order ||= Order.find(params[:id])
  end

  def not_found
    redirect_back_or_to root_path, alert: "Order not found", status: :not_found
  end
end
