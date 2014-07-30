require File.expand_path('../boot', __FILE__)

# Pick the frameworks you want:
require "active_model/railtie"
require "active_record/railtie"
require "action_controller/railtie"
require "action_mailer/railtie"
require "action_view/railtie"
require "sprockets/railtie"
# require "rails/test_unit/railtie"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module BoB
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    # config.time_zone = 'Central Time (US & Canada)'

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    # config.i18n.default_locale = :de

    # Uncomment to use proper locales
    # config.i18n.default_locale = :en
    # config.i18n.available_locales = [:en, :pl]
    # config.i18n.available_locales = [:en]
    # config.i18n.enforce_available_locales = true
    # I18n.config.enforce_available_locales = true
    # config.i18n.fallbacks = true

    config.assets.precompile += %w(*.png *.jpg *.jpeg *.gif)
    config.autoload_paths += %W(#{config.root}/lib)

    config.chapters_path = Rails.root.join('chapters')
    config.book_title = "Blog-o-Book"
    config.book_author = "Tomek Gryszkiewicz"
    config.book_author_email = "grych@tg.pl"
    config.default_view = :blog # or :book
    config.show_chapter_no = true
  end
end
