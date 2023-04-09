# frozen_string_literal: true

$LOAD_PATH.unshift File.expand_path("../lib", __dir__)
require "mayfly"

require "minitest/autorun"
require "minitest/focus"
require "minitest/reporters"
require "webmock/minitest"
require "debug"

Minitest::Reporters.use! [Minitest::Reporters::DefaultReporter.new(color: true)]
