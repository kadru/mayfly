# frozen_string_literal: true

require "test_helper"
require "mayfly/infrastructure/http_client"

class TestHttpClientSelfCreate < Minitest::Test
  def test_create_subscription_request_mayfly_client_event
    stub_request(:get, "https://www.example.com/")

    http_client = Mayfly::HttpClient.create(method: :get, uri: "https://www.example.com")

    @subscriber = Mayfly::Notifications.monotonic_subscribe do |name, start, finish, id, _payload|
      assert_event(name:, start:, finish:, id:)
    end

    http_client.make_request
  end

  def test_create_null_subscription_request_mayfly_client_event
    http_client = Mayfly::HttpClient.create_null(method: :get, uri: "https://www.example.com")

    @subscriber = Mayfly::Notifications.monotonic_subscribe do |name, start, finish, id, _payload|
      assert_event(name:, start:, finish:, id:)
    end

    http_client.make_request
  end

  def test_create_subscription_request_mayfly_client_event_payload
    stub_request(:get, "https://www.example.com")
      .to_return(
        body: "hello world",
        headers: {
          content_type: "text/plain",
          content_length: "11"
        }
      )

    http_client = Mayfly::HttpClient.create(method: :get, uri: "https://www.example.com")

    @subscriber = Mayfly::Notifications.monotonic_subscribe do |_name, _start, _finish, _id, payload|
      response = payload.fetch(:response)

      assert_response response
    end

    http_client.make_request
  end

  def test_create_null_subscription_request_mayfly_client_event_payload
    http_client = Mayfly::HttpClient.create_null(method: :get, uri: "https://www.example.com")

    @subscriber = Mayfly::Notifications.monotonic_subscribe do |_name, _start, _finish, _id, payload|
      response = payload.fetch(:response)

      assert_response response
    end

    http_client.make_request
  end

  def test_create_subscription_request_mayfly_client_event_payload_request
    stub_request(:get, "https://www.example.com/")
      .to_return(
        body: "hello world",
        headers: {
          content_type: "text/plain",
          content_length: "11"
        }
      )

    http_client = Mayfly::HttpClient.create(method: :get, uri: "https://www.example.com")

    @subscriber = Mayfly::Notifications.monotonic_subscribe do |_name, _start, _finish, _id, payload|
      request = payload.fetch(:response).request

      assert_request request
    end

    http_client.make_request
  end

  def test_create_null_subscription_request_mayfly_client_event_payload_request
    stub_request(:get, "https://www.example.com/")
      .to_return(
        body: "hello world",
        headers: {
          content_type: "text/plain",
          content_length: "11"
        }
      )

    http_client = Mayfly::HttpClient.create_null(method: :get, uri: "https://www.example.com")

    @subscriber = Mayfly::Notifications.monotonic_subscribe do |_name, _start, _finish, _id, payload|
      request = payload.fetch(:response).request

      assert_request request
    end

    http_client.make_request
  end

  def test_create_subscription_request_mayfly_client_event_payload_uri
    stub_request(:get, "https://www.example.com/path")

    http_client = Mayfly::HttpClient.create(method: :get, uri: "https://www.example.com/path")

    @subscriber = Mayfly::Notifications.monotonic_subscribe do |_name, _start, _finish, _id, payload|
      uri = payload.fetch(:response).uri

      assert_uri uri
    end

    http_client.make_request
  end

  def test_create_null_subscription_request_mayfly_client_event_payload_uri
    stub_request(:get, "https://www.example.com/path")

    http_client = Mayfly::HttpClient.create_null(method: :get, uri: "https://www.example.com/path")

    @subscriber = Mayfly::Notifications.monotonic_subscribe do |_name, _start, _finish, _id, payload|
      uri = payload.fetch(:response).uri

      assert_uri uri
    end

    http_client.make_request
  end

  def teardown
    Mayfly::Notifications.unsubscribe @subscriber
  end

  private

  # Asserts compatibility with MayFly:HttpClient.create and MayFly:HttpClient.create_null

  def assert_event(name:, start:, finish:, id:)
    assert_equal "request.mayfly_client", name
    assert_kind_of Float, start # start time varies a lot during test, so simply test that is float
    assert_kind_of Float, finish # start time varies a lot during test, so simply test that is float
    assert_kind_of String, id # id is non-deterministic, so simply test that is a String
  end

  def assert_response(response)
    assert_equal "1.1", response.version
    assert_equal "https://www.example.com/", response.uri.to_s
    assert_equal 200, response.status
    assert_equal "text/plain", response.mime_type
    assert_equal 11, response.content_length
    assert_equal "hello world", response.body.to_s
  end

  def assert_request(request)
    assert_equal "1.1", request.version
    assert_equal "https://www.example.com/", request.uri.to_s
    assert_equal :get, request.verb
  end

  def assert_uri(uri)
    assert_equal "https", uri.scheme
    assert_equal "/path", uri.path
    assert_equal "www.example.com", uri.host
  end
end
