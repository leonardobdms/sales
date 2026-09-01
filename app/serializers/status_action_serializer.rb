# frozen_string_literal: true

class StatusActionSerializer < ApplicationSerializer
  StatusAction = Data.define(:event, :label, :variant, :to)

  DESTRUCTIVE_EVENTS = %w[cancel fail].freeze

  typelize event: :string
  typelize label: :string
  typelize variant: :string
  typelize to: :string

  attributes :event, :label, :variant, :to

  def self.for(record)
    record.aasm.events(permitted: true).map do |event|
      transition = Array(event.transitions_from_state(record.aasm.current_state)).first
      name = event.name.to_s

      StatusAction.new(
        event: name,
        label: event.options[:display].presence || event.default_display_name,
        variant: DESTRUCTIVE_EVENTS.include?(name) ? "destructive" : "default",
        to: transition.to.to_s
      )
    end
  end
end
