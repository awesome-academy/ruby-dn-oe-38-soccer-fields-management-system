ENV["RAILS_ENV"] ||= "test"

require "spec_helper"
require "shoulda/matchers"
require "support/database_cleaner"
require "factory_bot"
require File.expand_path("../config/environment", __dir__)
require "rspec/rails"
require "support/auth_helper"

abort("The Rails environment is running in production mode!") if Rails.env.production?

begin
  ActiveRecord::Migration.maintain_test_schema!
rescue ActiveRecord::PendingMigrationError => e
  puts e.to_s.strip
  exit 1
end

RSpec.configure do |config|
  config.fixture_path = "#{::Rails.root}/spec/fixtures"
  config.include(Shoulda::Matchers::ActiveModel, type: :model)
  config.include(Shoulda::Matchers::ActiveRecord, type: :model)

  config.infer_spec_type_from_file_location!

  config.filter_rails_from_backtrace!

  config.include(AuthHelper, type: :request)
  config.include FactoryBot::Syntax::Methods

  config.before(:suite) do
    FactoryBot.find_definitions
  end
end

Shoulda::Matchers.configure do |config|
  config.integrate do |with|
    with.test_framework :rspec
    with.library :active_record
    with.library :active_model
    with.library :action_controller
    with.library :rails
  end
end
