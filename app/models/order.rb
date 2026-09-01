class Order < ApplicationRecord
  include AASM

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
end
