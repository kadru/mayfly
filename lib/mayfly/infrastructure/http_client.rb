# frozen_string_literal: true

require "http"
require "mayfly/utils/notifications"

module Mayfly
  # Client to make http requests with instrumentation
  class HttpClient
    def self.create(uri:, method: :get)
      new(
        method:,
        uri:,
        http: HTTP.use(
          instrumentation: {
            instrumenter: Mayfly::Notifications.instrumenter,
            namespace: Mayfly::Notifications.namespace
          }
        )
      )
    end

    def self.create_null(method: :get, uri: "http://example.com/")
      new(
        method:,
        uri:,
        http: StubbedHttp.use(
          instrumentation: {
            instrumenter: Mayfly::Notifications.instrumenter,
            namespace: Mayfly::Notifications.namespace
          }
        )
      )
    end

    def initialize(method:, uri:, http:)
      @http = http
      @method = method
      @uri = uri
    end

    def make_request
      http.request method, uri
    end

    private

    attr_reader :http, :uri, :method

    # Stubbed http to use in tests
    class StubbedHttp
      Response = Data.define(:status, :version, :body, :mime_type, :content_length, :request) do
        def uri
          request.uri
        end
      end

      Request = Data.define(:verb, :uri, :version) do
        def initialize(verb:, uri:, version:)
          super(verb:, version:, uri: HTTP::URI::NORMALIZER.call(uri))
        end

        def scheme
          uri.scheme
        end
      end

      # @param [Hash] opts
      def self.use(opts = {})
        instrumentation = opts.fetch(:instrumentation)
        new(
          instrumenter: instrumentation[:instrumenter],
          namespace: instrumentation[:namespace]
        )
      end

      def initialize(opts = {})
        namespace = opts.fetch(:namespace, "http")
        @instrumenter = opts.fetch(:instrumenter)
        @name = "request.#{namespace}"
      end

      def request(verb, uri, _opts = {})
        version = "1.1"
        mime_type = "text/plain"
        content_length = 11

        request = Request.new(verb:, uri:, version:)
        instrumenter.instrument("start_#{name}", request:)

        instrumenter.start(name, request:)
        response = Response.new(
          status: 200,
          version:,
          body: "hello world",
          mime_type:,
          content_length:,
          request:
        )
        instrumenter.finish(name, response:)

        response
      end

      private

      attr_reader :name, :instrumenter
    end
  end
end
