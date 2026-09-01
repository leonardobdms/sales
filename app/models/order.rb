class Order < ApplicationRecord
  include AASM

  after_create_commit :publish_created
  after_update_commit :publish_status_event

  aasm column: :status do
    state :pending, initial: true
    state :confirmed
    state :preparing
    state :shipped
    state :delivered
    state :cancelled

    event :confirm do
      transitions from: :pending, to: :confirmed
    end

    event :start_preparing, display: "Prepare" do
      transitions from: :confirmed, to: :preparing
    end

    event :ship do
      transitions from: :preparing, to: :shipped
    end

    event :deliver do
      transitions from: :shipped, to: :delivered
    end

    event :cancel do
      transitions from: %i[pending confirmed preparing], to: :cancelled
    end
  end

  private

  def publish_created
    ::OrderEventPublisher.created(self)
  end

  def publish_status_event
    return unless saved_change_to_status?

    case status
    when "confirmed" then ::OrderEventPublisher.confirmed(self)
    when "cancelled" then ::OrderEventPublisher.cancelled(self)
    end
  end
end
