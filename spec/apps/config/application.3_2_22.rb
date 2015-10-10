require "celluloid-io-pg-listener" # this gem

module Rails_3_2_22
  class Application < Rails::Application
    config.root = File.join(Rails.root, "spec/apps")

    config.cache_classes = true

    config.autoload_paths += Dir["#{Rails.root}/app/models/*/**/*"]

    config.eager_load = false
    config.serve_static_assets  = true
    config.static_cache_control = "public, max-age=3600"

    config.consider_all_requests_local       = true
    config.action_controller.perform_caching = false

    config.action_dispatch.show_exceptions = false

    config.action_controller.allow_forgery_protection = false

    config.active_support.deprecation = :stderr

    config.middleware.delete "Rack::Lock"
    config.middleware.delete "ActionDispatch::Flash"
    config.middleware.delete "ActionDispatch::BestStandardsSupport"
    config.secret_token = "49837489qkuweoiuoqwehisuakshdjksadhaisdy78o34y138974xyqp9rmye8yrpiokeuioqwzyoiuxftoyqiuxrhm3iou1hrzmjk"
  end
end

Rails_3_2_22::Application.initialize!
