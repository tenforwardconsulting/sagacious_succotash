module SagaciousSuccotash
  class AppBuilder < Rails::AppBuilder
    include SagaciousSuccotash::Actions
    include SagaciousSuccotash::Helpers

    def replace_gemfile
      remove_file 'Gemfile'
      template 'Gemfile.erb', 'Gemfile'
    end

    def remove_comments_from_routes
      replace_in_file 'config/routes.rb',
        /Rails\.application\.routes\.draw do.*end/m,
        "Rails.application.routes.draw do\nend"
    end

    def set_ruby_to_version_being_used
      create_file '.ruby-version', "#{SagaciousSuccotash::RUBY_VERSION}\n"
    end

    def set_gemset_name_to_application_name
      create_file '.ruby-gemset', "#{app_name}\n"
    end

    def make_rvm_use_application_gemset
      require 'rvm'
      rvm = RVM::Environment.new(SagaciousSuccotash::RUBY_VERSION)
      rvm.gemset_use!(app_name)
    end

    def install_bundler_gem
      run 'gem install bundler'
    end

    def configure_database
      template 'database.yml.erb', 'config/database.yml', force: true
    end

    def create_database
      bundle_command 'exec rake db:create db:migrate'
    end

    def configure_simple_form
      bundle_command "exec rails generate simple_form:install"
    end

    def raise_on_delivery_errors
      replace_in_file 'config/environments/development.rb',
        "# Don't care if the mailer can't send.", "# Raise error if the mailer can't send."
      replace_in_file 'config/environments/development.rb',
        'raise_delivery_errors = false', 'raise_delivery_errors = true'
    end

    def set_mailer_delivery_method
      inject_into_file(
        "config/environments/development.rb",
        "\n\n  # Open emails with letter_opener.\n  config.action_mailer.delivery_method = :letter_opener",
        after: "config.action_mailer.raise_delivery_errors = true",
      )
    end

    def perform_deliveries
      inject_into_file(
        "config/environments/development.rb",
        "\n\n  # Send emails.\n  config.action_mailer.perform_deliveries = true",
        after: "config.action_mailer.delivery_method = :letter_opener",
      )
    end

    def set_default_url_options
      inject_into_file(
        "config/environments/development.rb",
        "\n\n  # Set email host.\n  config.action_mailer.default_url_options = { host: 'localhost', port: 3000 }",
        after: "config.action_mailer.perform_deliveries = true",
      )
    end

    def raise_on_unpermitted_parameters
      config = <<-RUBY
    # Raise an error for unpermitted parameters.
    config.action_controller.action_on_unpermitted_parameters = :raise

      RUBY
      inject_into_class "config/application.rb", "Application", config
    end

    def set_sass_as_preferred_stylesheet_syntax
      config = <<-RUBY
    # Use .sass instead of .scss.
    config.sass.preferred_syntax = :sass

      RUBY
      inject_into_class 'config/application.rb', 'Application', config
    end

    def configure_generators
      config = <<-RUBY
    # No helper, javascript, jbuilder files or extraneous spec files.
    config.generators do |generate|
      generate.helper false
      generate.javascripts false
      generate.jbuilder false
      generate.test_framework :rspec, {
        controller_specs: false,
        request_specs: false,
        routing_specs: false,
        view_specs: false
      }
      generate.factory_girl filename_proc: -> (table_name) { "\#{table_name}_factory" } # Only works for master branch of FactoryGirl.
    end

      RUBY
      inject_into_class 'config/application.rb', 'Application', config
    end

    def configure_i18n_for_missing_translations
      raise_on_missing_translations_in "development"
      raise_on_missing_translations_in "test"
    end

    def generate_rspec
      generate 'rspec:install'
    end

    def configure_rspec
      remove_file "spec/rails_helper.rb"
      remove_file "spec/spec_helper.rb"
      copy_file "rails_helper.rb", "spec/rails_helper.rb"
      copy_file "spec_helper.rb" , "spec/spec_helper.rb"
      copy_file "capybara.rb"           , "spec/support/capybara.rb"
      copy_file "capybara_screenshot.rb", "spec/support/capybara_screenshot.rb"
      copy_file "controller_helpers.rb" , "spec/support/controller_helpers.rb"
      copy_file "database_cleaner.rb"   , "spec/support/database_cleaner.rb"
      # TODO Move to devise install area after that's added
      copy_file "devise.rb"             , "spec/support/devise.rb"
      copy_file "feature_helpers.rb"    , "spec/support/feature_helpers.rb"
      # TODO Move to api install area after that's added
      template "request_helpers.rb.erb", "spec/support/request_helpers.rb"
      copy_file "timecop.rb"            , "spec/support/timecop.rb"
      copy_file "vcr.rb"                , "spec/support/vcr.rb"
      copy_file "wait_for_ajax.rb"      , "spec/support/wait_for_ajax.rb"
    end

    def convert_erbs_to_haml
      bundle_command 'exec rake haml:replace_erbs'
    end

    def setup_application_layout
      template 'application.html.haml.erb', 'app/views/layouts/application.html.haml', force: true
      copy_file '_nav.haml', 'app/views/layouts/_nav.haml'
    end

    def setup_stylesheets
      remove_file 'app/assets/stylesheets/application.css'
      directory 'stylesheets', 'app/assets/stylesheets'
    end

    def require_self_before_require_tree
      insert_into_file(
        'app/assets/javascripts/application.js',
        "//= require_self\n",
        before: '//= require_tree .'
      )
    end

    def add_javascript_namespace
      append_to_file 'app/assets/javascripts/application.js', "\nwindow.#{app_name.camelize} = {};"
    end

    def remove_turbolinks
      gsub_file 'app/assets/javascripts/application.js', "//= require turbolinks\n", ''
    end

    def setup_application_mailer
      template 'mailer/application_mailer.rb.erb', 'app/mailers/application_mailer.rb'
    end

    def setup_mailer_layout
      copy_file 'mailer/mailer.html.haml', 'app/views/layouts/mailer.html.haml'
    end

    def setup_mailer_stylesheets
      copy_file 'mailer/email.sass', 'app/assets/stylesheets/email.sass'
      directory 'mailer/email', 'app/assets/stylesheets/email'
    end

    def precompile_email_sass
      append_to_file 'config/initializers/assets.rb', "Rails.application.config.assets.precompile += %w(email.css)"
    end

    def setup_home_controller
      copy_file 'home_controller.rb', 'app/controllers/home_controller.rb'
      create_file 'app/views/home/index.html.haml', ''
      insert_into_file(
        'config/routes.rb',
        "\n  root to: 'home#index'",
        after: 'Rails.application.routes.draw do'
      )
    end

    private

    def raise_on_missing_translations_in(environment)
      config = 'config.action_view.raise_on_missing_translations = true'
      uncomment_lines("config/environments/#{environment}.rb", config)
    end
  end
end
