# frozen_string_literal: true

require "active_support"
require "active_support/notifications"

module Mayfly
  # Manage instrumentation to requests
  class Notifications
    def self.monotonic_subscribe(callable = nil, &block)
      ActiveSupport::Notifications.monotonic_subscribe("request.#{namespace}", callable || block)
    end

    def self.instrumenter = ActiveSupport::Notifications.instrumenter

    def self.namespace = "mayfly_client"

    def self.unsubscribe(subscriber)
      ActiveSupport::Notifications.unsubscribe(subscriber)
    end
  end
end
