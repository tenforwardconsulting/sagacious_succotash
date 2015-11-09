require 'rails/generators'
require 'rails/generators/rails/app/app_generator'

module SagaciousSuccotash
  class AppGenerator < Rails::Generators::AppGenerator

    def finish_template
      invoke :sagacious_succotash_customization
      super
    end

    def sagacious_succotash_customization
      invoke :customize_gemfile
      invoke :setup_rvm
      invoke :setup_database
      invoke :setup_simple_form
      invoke :setup_development_environment
      invoke :outro
    end

    def customize_gemfile
      build :replace_gemfile
    end

    def setup_rvm
      build :set_ruby_to_version_being_used
      build :set_gemset_name_to_application_name
      build :make_rvm_use_application_gemset
      build :install_bundler_gem
      bundle_command 'install'
    end

    def setup_database
      build :configure_database
      build :create_database
    end

    def setup_simple_form
      build :configure_simple_form
    end

    def setup_development_environment
      build :raise_on_delivery_errors
      build :set_mailer_delivery_method
      build :raise_on_unpermitted_parameters
      build :set_sass_as_preferred_stylesheet_syntax
      build :configure_generators
      build :configure_i18n_for_missing_translations
    end

    def outro
      say 'Mmmm, succotash.'
    end

    protected

    def get_builder_class
      SagaciousSuccotash::AppBuilder
    end
  end
end
