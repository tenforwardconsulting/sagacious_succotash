require 'rails/generators'
require 'rails/generators/rails/app/app_generator'

module SagaciousSuccotash
  class AppGenerator < Rails::Generators::AppGenerator
    include SagaciousSuccotash::Helpers

    def finish_template
      invoke :sagacious_succotash_customization
      super
    end

    def sagacious_succotash_customization
      invoke :customize_gemfile
      invoke :customize_routes
      invoke :setup_rvm
      invoke :configure_app
      invoke :setup_database
      invoke :setup_simple_form
      invoke :setup_development_environment
      invoke :setup_test_environment
      invoke :convert_erbs_to_haml
      invoke :setup_layout
      invoke :setup_stylesheets
      invoke :setup_javascript
      invoke :setup_mailer
      invoke :setup_home_controller
      invoke :setup_devise
      invoke :setup_delayed_job
      invoke :setup_capistrano
      invoke :setup_git
      invoke :outro
    end

    def customize_gemfile
      build :replace_gemfile
    end

    def customize_routes
      build :remove_comments_from_routes
    end

    def setup_rvm
      build :set_ruby_to_version_being_used
      build :set_gemset_name_to_application_name
      build :make_rvm_use_application_gemset
      build :install_bundler_gem
      bundle_command 'install'
    end

    def configure_app
      build :setup_application_yml
      build :setup_secrets_yml
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
      build :perform_deliveries
      build :set_default_url_options
      build :raise_on_unpermitted_parameters
      build :set_sass_as_preferred_stylesheet_syntax
      build :configure_generators
      build :configure_i18n_for_missing_translations
    end

    def setup_test_environment
      build :generate_rspec
      build :configure_rspec
    end

    def convert_erbs_to_haml
      build :convert_erbs_to_haml
    end

    def setup_layout
      build :setup_application_layout
    end

    def setup_stylesheets
      build :setup_stylesheets
    end

    def setup_javascript
      build :require_self_before_require_tree
      build :add_javascript_namespace
      build :remove_turbolinks
    end

    def setup_mailer
      build :setup_application_mailer
      build :setup_mailer_layout
      build :setup_mailer_stylesheets
      build :precompile_email_sass
    end

    def setup_home_controller
      build :setup_home_controller
    end

    def setup_devise
      build :install_devise
      build :set_parent_mailer
      build :change_min_password_length
      build :allow_get_request_to_log_out
      build :change_application_mailer_default_from
      build :setup_devise_stylesheet
      build :setup_devise_spec_support
      build :add_auth_links_to_nav
      build :generate_user_model
      build :add_admin_to_user_model
      build :add_admin_methods_to_application_controller
      build :setup_users_factory
      build :configure_devise_routes
      # TODO
      # create basic crud pages and stylesheet? This should use controller scaffold (need to copy over templates/generators for this)
      # Controller should have correct authorization (pundit?)
    end

    def setup_delayed_job
      build :setup_delayed_job
    end

    def setup_capistrano
      build :install_capistrano
      build :configure_deploys
      build :setup_dev_environments_file
      build :configure_capfile
    end

    def setup_git
      build :setup_git
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
