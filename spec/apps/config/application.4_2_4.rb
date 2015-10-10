require "celluloid-io-pg-listener" # this gem

module Rails_4_2_4
  class Application < Rails::Application
    config.root = File.join(Rails.root, "spec/apps")

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

    config.middleware.delete "Rack::Lock"
    config.middleware.delete "ActionDispatch::Flash"
    config.middleware.delete "ActionDispatch::BestStandardsSupport"
    config.secret_key_base = "49837489qkuweoiuoqwehisuakshdjksadhaisdy78o34y138974xyqp9rmye8yrpiokeuioqwzyoiuxftoyqiuxrhm3iou1hrzmjk"
  end
end

Rails_4_2_4::Application.initialize!
