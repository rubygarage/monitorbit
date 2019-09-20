# frozen_string_literal: true

require 'simplecov'
SimpleCov.start

RSpec.configure do |config|
  config.mock_with(:rspec) { |mocks| mocks.verify_partial_doubles = true }
  config.shared_context_metadata_behavior = :apply_to_host_groups
end
