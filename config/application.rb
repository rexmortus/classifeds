require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)



module Classifeds
  class Application < Rails::Application
    config.generators do |generate|
      generate.assets false
      generate.helper false
      generate.test_framework  :test_unit, fixture: false
      generate.orm :active_record, primary_key_type: :uuid
      generate.orm :active_record, foreign_key_type: :uuid
    end
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 6.0

    classifeds_config = YAML.load(File.open('.classifeds.yml').read)

    config.classifeds_default_location = classifeds_config['default_location']
    config.classifeds_default_geocode = Geocoder.search(config.classifeds_default_location).first.coordinates
    config.classifeds_categories = classifeds_config['categories']
    config.classifeds_types = classifeds_config['types']
    config.classifeds_max_search_distance = classifeds_config['max_search_distance']
    config.classifeds_default_search_distance = classifeds_config['default_search_distance']

    # Load and sign the Classifeds pledge
    markdown = Redcarpet::Markdown.new(Redcarpet::Render::HTML, autolink: true, tables: true)
    pledge_markdown = File.open('.pledge.md').read
    config.classifeds_pledge = markdown.render(pledge_markdown)

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration can go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded after loading
    # the framework and any gems in your application.
  end
end
