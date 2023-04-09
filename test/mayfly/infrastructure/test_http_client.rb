# frozen_string_literal: true

require "test_helper"
require "mayfly/infrastructure/http_client"

class TestRequestListener < Minitest::Test
  def test_make_request_get
    run_act_method_test :get

    assert_requested :get, "example.com"
  end

  def test_make_request_post
    run_act_method_test :post

    assert_requested :post, "example.com"
  end

  def test_make_request_put
    run_act_method_test :put

    assert_requested :put, "example.com"
  end

  def test_make_request_patch
    run_act_method_test :patch

    assert_requested :patch, "example.com"
  end

  def test_make_request_delete
    run_act_method_test :delete

    assert_requested :delete, "example.com"
  end

  private

  def run_act_method_test(method)
    stub_request(method, "example.com")
    http_client = Mayfly::HttpClient.new(method:, uri: "http://example.com", http: HTTP)

    http_client.make_request
  end
end
