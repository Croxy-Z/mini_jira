# frozen_string_literal: true

# This file is copied to spec/ when you run 'rails generate rspec:install'
require "spec_helper"
ENV["RAILS_ENV"] ||= "test"
require_relative "../config/environment"
raise "The Rails environment is running in production mode!" if Rails.env.production?

require "rspec/rails"
require "shoulda/matchers"
require "socket"

ActiveRecord::Migration.maintain_test_schema!

Capybara.server_host = "0.0.0.0"
Capybara.server_port = 3001
Capybara.app_host = "http://#{IPSocket.getaddress(Socket.gethostname)}:#{Capybara.server_port}"

Capybara.register_driver :selenium_chrome_headless_remote do |app|
  options = Selenium::WebDriver::Chrome::Options.new

  options.add_argument("--headless=new")
  options.add_argument("--no-sandbox")
  options.add_argument("--disable-dev-shm-usage")
  options.add_argument("--disable-gpu")
  options.add_argument("--window-size=1400,1400")

  Capybara::Selenium::Driver.new(
    app,
    browser: :remote,
    url: ENV.fetch("SELENIUM_REMOTE_URL", "http://selenium:4444/wd/hub"),
    options:
  )
end

RSpec.configure do |config|
  config.before(:each, type: :system) do
    driven_by :selenium_chrome_headless_remote
  end

  config.fixture_paths = [
    Rails.root.join("spec/fixtures")
  ]

  config.include FactoryBot::Syntax::Methods
  config.include Devise::Test::IntegrationHelpers, type: :request
  config.include Devise::Test::IntegrationHelpers, type: :system
  config.include ViewComponent::TestHelpers, type: :component

  config.use_transactional_fixtures = true
  config.filter_rails_from_backtrace!
  config.infer_spec_type_from_file_location!
end

Shoulda::Matchers.configure do |config|
  config.integrate do |with|
    with.test_framework :rspec
    with.library :rails
  end
end
