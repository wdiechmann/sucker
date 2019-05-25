require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Sucker
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 5.1

    # emulate the import of environment variables
    # something that Figaro and Foreman 'should' do
    config.before_configuration do
      env='.'+Rails.env
      env_file = File.join(Rails.root, '.env'+env)
      File.open(env_file).each do |line|
        line=line.split('#')[0]
        key,value=line.split("=") rescue [nil,nil]
        ((ENV[key.to_s] = value.gsub( /\n/,'')) unless key.nil?) rescue nil
      end if File.exists?(env_file)
      # ENV.each {|k,v| puts "#{k} #{v}" }
    end
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.
  end
end
