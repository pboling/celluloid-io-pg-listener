$LOAD_PATH.unshift File.expand_path("../../lib", __FILE__)
require "celluloid-io-pg-listener"

require "rails"
require "apps/rails_#{Rails.version.gsub(/\./, "_")}"
