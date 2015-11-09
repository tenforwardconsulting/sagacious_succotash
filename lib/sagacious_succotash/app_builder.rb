module SagaciousSuccotash
  class AppBuilder < Rails::AppBuilder
    include SagaciousSuccotash::Actions

    def replace_gemfile
      remove_file 'Gemfile'
      template 'Gemfile.erb', 'Gemfile'
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
        'raise_delivery_errors = false', 'raise_delivery_errors = true'
    end

    def set_mailer_delivery_method
      inject_into_file(
        "config/environments/development.rb",
        "\n  config.action_mailer.delivery_method = :test",
        after: "config.action_mailer.raise_delivery_errors = true",
      )
    end

    def raise_on_unpermitted_parameters
      config = <<-RUBY
    config.action_controller.action_on_unpermitted_parameters = :raise
      RUBY
      inject_into_class "config/application.rb", "Application", config
    end

    def set_sass_as_preferred_stylesheet_syntax
      config = <<-RUBY

    # Use .sass instead of .scss
    config.sass.preferred_syntax = :sass
      RUBY
      inject_into_class 'config/application.rb', 'Application', config
    end

    def configure_generators
      config = <<-RUBY

    # No helper, javascript, jbuilder files or extraneous spec files.
    # TODO Figure out how to not generate scaffold.sass. There doesn't appear to be an option for it.
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
      generate.factory_girl filename_proc: -> (table_name) { "#{table_name}_factory" } # Only works for master branch of FactoryGirl.
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
      copy_file "devise.rb"             , "spec/support/devise.rb"
      copy_file "feature_helpers.rb"    , "spec/support/feature_helpers.rb"
      copy_file "request_helpers.rb.erb", "spec/support/request_helpers.rb.erb"
      copy_file "timecop.rb"            , "spec/support/timecop.rb"
      copy_file "vcr.rb"                , "spec/support/vcr.rb"
      copy_file "wait_for_ajax.rb"      , "spec/support/wait_for_ajax.rb"
    end

    private

    def raise_on_missing_translations_in(environment)
      config = 'config.action_view.raise_on_missing_translations = true'
      uncomment_lines("config/environments/#{environment}.rb", config)
    end
  end
end
