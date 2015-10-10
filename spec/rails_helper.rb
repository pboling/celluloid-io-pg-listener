# This file is copied to spec/ when you run 'rails generate rspec:install'
require "bundler/setup"

require "spec_helper"

ENV["RAILS_ENV"] = "test"

require "rails"
require "active_record"

ActiveRecord::Base.logger = Logger.new(File.dirname(__FILE__) + "/debug.log")
ActiveRecord::Migration.verbose = false

database_yml_filepath = File.dirname(__FILE__) + "/apps/config/database.yml"
configs = YAML.load_file(database_yml_filepath)
if RUBY_PLATFORM == "java"
  configs["test"]["adapter"] = "jdbcpostgresql"
end
ActiveRecord::Base.configurations = configs

db_name = (ENV["DB"] || "test").to_sym
ActiveRecord::Base.establish_connection(db_name)

require "active_record/railtie"

require "apps/config/application.#{Rails.version.gsub(/\./, "_")}"

# Prevent database truncation if the environment is production
abort("The Rails environment is running in production mode!") if Rails.env.production?
require "rspec/rails"

RSpec.configure do |config|
  config.use_transactional_fixtures = true
end
