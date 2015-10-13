require "bundler/setup"
require "bundler/gem_tasks"
require "rspec/core/rake_task"
require "celluloid-io-pg-listener"

RSpec::Core::RakeTask.new(:spec)

require "rails"
require "active_record"

# this logging style not compatible with Travis
# ActiveRecord::Base.logger = Logger.new(File.dirname(__FILE__) + "/spec/apps/log/debug.log")
ActiveRecord::Migration.verbose = false

database_yml_filepath = File.dirname(__FILE__) + "/spec/apps/config/database.yml"
configs = YAML.load_file(database_yml_filepath)
if RUBY_PLATFORM == "java"
  configs["test"]["adapter"] = "jdbcpostgresql"
end
ActiveRecord::Base.configurations = configs

db_name = (ENV["DB"] || "test").to_sym
ActiveRecord::Base.establish_connection(db_name)

require "active_record/railtie"

task :default => :spec
