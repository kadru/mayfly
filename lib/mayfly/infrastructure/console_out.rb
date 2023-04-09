# frozen_string_literal: true

require "mayfly/infrastructure/output_listener"

module Mayfly
  # Manage all standard output
  class ConsoleOut
    def self.create
      new(
        stdout: $stdout
      )
    end

    def self.create_null
      new(
        stdout: StubbedIO.new
      )
    end

    def initialize(stdout:)
      @stdout = stdout
      @output_listener = OutputListener.new
    end

    def puts(*args)
      stdout.puts(args)
      output_listener.emit(*args)
    end

    def track_output
      output_listener.track_output
    end

    private

    attr_reader :stdout, :output_listener

    # Stubbed IO output class to use in testing
    class StubbedIO
      def puts(*_args) = nil
    end
  end
end
