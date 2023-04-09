# frozen_string_literal: true

require "test_helper"

class TestApp < Minitest::Test
  def test_render_print_method_and_path_of_a_request
    http_client = Mayfly::HttpClient.create_null method: :get, uri: "http://example.com/path"
    console_out = Mayfly::ConsoleOut.create_null
    output = console_out.track_output
    app = Mayfly::App.new(http_client:, console_out:)

    app.run

    assert_equal(["get /path"], output.data)
  end
end
