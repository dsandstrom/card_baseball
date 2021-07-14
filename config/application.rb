# frozen_string_literal: true

require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module CardBaseball
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 6.1

    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    #
    # config.time_zone = "Central Time (US & Canada)"
    # config.eager_load_paths << Rails.root.join("extras")

    # autoload classes directory
    config.autoload_paths << File.join(Rails.root, 'classes')

    config.generators do |g|
      g.test_framework :rspec, fixture: false
      g.assets false
      g.helper false
      g.jbuilder false
      g.fixture_replacement :fabrication
      g.request_specs false
      g.routing_specs false
    end
  end
end
