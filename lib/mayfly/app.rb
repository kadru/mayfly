# frozen_string_literal: true

require "mayfly/infrastructure/http_client"
require "mayfly/infrastructure/request_listener"
require "mayfly/infrastructure/console_out"

module Mayfly
  # Application entrypoint
  class App
    def self.create; end

    def initialize(http_client:, console_out:)
      @http_client = http_client
      @console_out = console_out
      ResquestListener.subscribe(console_out:)
    end

    def run
      http_client.make_request
    end

    private

    attr_reader :http_client
  end
end
