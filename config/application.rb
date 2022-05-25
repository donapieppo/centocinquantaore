require_relative 'boot'

require "rails/all"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Centocinquantaore
  class Application < Rails::Application
    config.load_defaults 7.0

    config.hosts << "tester.dm.unibo.it"
    config.hosts << "www.dm.unibo.it"

    config.authlevels = {read: 1, manage: 2}

    config.time_zone = 'Rome'
    config.i18n.default_locale = :it

    config.dm_unibo_common = ActiveSupport::HashWithIndifferentAccess.new config_for(:dm_unibo_common)
  end
end
