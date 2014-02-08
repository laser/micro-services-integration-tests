require 'rspec'
require 'capybara'
require 'capybara/dsl'
require 'net/http'
require 'pry'

module CapybaraStandalone
  def self.setup
    Capybara.configure do |config|
      config.app_host       = ENV['TEST_URL'] || 'http://localhost:5000'
      config.run_server     = false
      config.default_driver = :selenium
    end
  end
end

RSpec.configure do |config|
  config.include Capybara::DSL

  config.before(:all) do
    CapybaraStandalone.setup
  end

  config.after do
    Capybara.reset_sessions!
    Capybara.use_default_driver
  end
end
