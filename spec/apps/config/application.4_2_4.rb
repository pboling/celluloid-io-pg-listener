require "rails"
require "active_record"

database_yml_filepath = File.dirname(__FILE__) + "/database.yml"
configs = YAML.load_file(database_yml_filepath)
if RUBY_PLATFORM == "java"
  configs["test"]["adapter"] = "jdbcpostgresql"
end
ActiveRecord::Base.configurations = configs

db_name = (ENV["DB"] || "test").to_sym
ActiveRecord::Base.establish_connection(db_name)

# this logging style not compatible with Travis
# ActiveRecord::Base.logger = Logger.new(File.dirname(__FILE__) + "/../log/debug.log")
ActiveRecord::Migration.verbose = false

require "active_record/railtie"

require "celluloid-io-pg-listener" # this gem

module Rails_4_2_4
  class Application < Rails::Application
    # When running commands from the spec/apps directory we can't override
    #   Rails root like this or it would be spec/apps/spec/apps
    config.root = File.join(Rails.root, "spec/apps") unless ENV["SKIP_RAILS_ROOT_OVERRIDE"]

    config.cache_classes = true

    config.autoload_paths += Dir["#{Rails.root}/app/models/*/**/*"]

    config.eager_load = false
    config.serve_static_files  = true
    config.static_cache_control = "public, max-age=3600"

    config.consider_all_requests_local       = true
    config.action_controller.perform_caching = false

    config.action_dispatch.show_exceptions = false

    config.action_controller.allow_forgery_protection = false

    config.active_support.deprecation = :stderr

    config.active_record.schema_format = :sql

    config.middleware.delete "Rack::Lock"
    config.middleware.delete "ActionDispatch::Flash"
    config.middleware.delete "ActionDispatch::BestStandardsSupport"
    config.secret_key_base = "49837489qkuweoiuoqwehisuakshdjksadhaisdy78o34y138974xyqp9rmye8yrpiokeuioqwzyoiuxftoyqiuxrhm3iou1hrzmjk"
  end
end

Rails_4_2_4::Application.initialize!
