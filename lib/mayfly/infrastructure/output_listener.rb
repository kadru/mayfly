# frozen_string_literal: true

require "active_support"
require "active_support/notifications"

module Mayfly
  # Listen for writes to stdout
  class OutputListener
    OUTPUT_EVENT = "console.output"

    def emit(data)
      ActiveSupport::Notifications.instrument(OUTPUT_EVENT, data)
    end

    def track_output
      OutputTracker.new(OUTPUT_EVENT)
    end
  end

  # Tracks all writes to stdout in data variable
  class OutputTracker
    attr_reader :data

    def initialize(event)
      @data = []
      @subscription = ActiveSupport::Notifications.subscribe(event) do |_name, _start, _finish, _id, payload|
        @data.push(payload)
      end
    end
  end
end
