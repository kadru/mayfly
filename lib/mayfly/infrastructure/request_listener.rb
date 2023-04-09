# frozen_string_literal: true

module Mayfly
  # Listens for requests made with HttpClient
  class ResquestListener
    attr_reader :console_out

    def self.subscribe(console_out:)
      new(console_out:).subscribe
    end

    def initialize(console_out:)
      @console_out = console_out
    end

    def call(*args)
      _event, _start, _finish, _response, event = args
      request = event.fetch(:response).request
      console_out.puts(
        "#{request.verb} #{request.uri.path}"
      )
    end

    def subscribe
      Notifications.monotonic_subscribe(self)
    end
  end
end
