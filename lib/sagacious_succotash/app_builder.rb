module SagaciousSuccotash
  class AppBuilder < Rails::AppBuilder
    include SagaciousSuccotash::Actions
    include SagaciousSuccotash::Helpers

    def replace_readme
      remove_file 'README.rdoc'
      template 'README.md.erb', 'README.md'
    end

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

    def setup_application_yml
      create_file 'config/application.yml', ''
      create_file 'config/application.yml.example', ''
    end

    def setup_secrets_yml
      template 'secrets.yml.erb', 'config/secrets.yml', force: true
      append_to_file 'config/application.yml', "SECRET_KEY_BASE: '#{app_secret}'"
      append_to_file 'config/application.yml.example', "SECRET_KEY_BASE: 'run `rake secret` and put value here'"
    end

    def configure_database
      template 'database.yml.erb', 'config/database.yml', force: true
    end

    def create_database
      bundle_command 'exec rake db:create db:migrate'
    end

    def configure_simple_form
      generate "simple_form:install"
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

    def setup_letter_opener_web
      insert_into_file 'config/routes.rb', after: 'Rails.application.routes.draw do' do
        <<-TEXT

  if Rails.env.development?
    mount LetterOpenerWeb::Engine, at: "/letter_opener"
  end
        TEXT
      end
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
      copy_file "rails_helper.rb"        , "spec/rails_helper.rb"
      copy_file "spec_helper.rb"         , "spec/spec_helper.rb"
      copy_file "capybara.rb"            , "spec/support/capybara.rb"
      copy_file "shared_examples.rb"     , "spec/support/shared_examples.rb"
      copy_file "capybara_screenshot.rb" , "spec/support/capybara_screenshot.rb"
      copy_file "controller_helpers.rb"  , "spec/support/controller_helpers.rb"
      copy_file "database_cleaner.rb"    , "spec/support/database_cleaner.rb"
      copy_file "feature_helpers.rb"     , "spec/support/feature_helpers.rb"
      template "request_helpers.rb.erb"  , "spec/support/request_helpers.rb" # TODO Move to api install area after that's added
      copy_file "timecop.rb"             , "spec/support/timecop.rb"
      copy_file "vcr.rb"                 , "spec/support/vcr.rb"
      copy_file "wait_for_ajax.rb"       , "spec/support/wait_for_ajax.rb"
    end

    def convert_erbs_to_haml
      bundle_command 'exec rake haml:replace_erbs'
    end

    def setup_application_layout
      template 'application.html.haml.erb', 'app/views/layouts/application.html.haml', force: true
      copy_file 'application_helper.rb', 'app/helpers/application_helper.rb', force: true
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

    def add_responsive_tables
      template 'responsive_tables.coffee.erb', 'app/assets/javascripts/responsive_tables.coffee'
    end

    def setup_templates
      directory 'templates', 'lib/templates'
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
        "\n  root to: 'home#index'\n",
        after: 'Rails.application.routes.draw do'
      )
    end

    def install_devise
      generate "devise:install"
      generate "devise:views"
      rake "haml:replace_erbs"
    end


    def set_parent_mailer
      insert_into_file(
        'config/initializers/devise.rb',
        "\n\n  # Set parent mailer so devise will have ApplicationMailer settings.\n  config.parent_mailer = 'ApplicationMailer'",
        after: "# config.mailer = 'Devise::Mailer'"
      )
    end

    def change_min_password_length
      gsub_file 'config/initializers/devise.rb', "config.password_length = 8..72", "config.password_length = 6..128"
    end

    def allow_get_request_to_log_out
      gsub_file 'config/initializers/devise.rb', "config.sign_out_via = :delete", "config.sign_out_via = [:delete, :get]"
    end

    def change_application_mailer_default_from
      gsub_file 'app/mailers/application_mailer.rb', "default from: 'please-change-me@example.com'", "default from: 'Devise.mailer_sender'"
    end

    def setup_devise_stylesheet
      copy_file 'devise_stylesheet.sass', 'app/assets/stylesheets/_devise.sass'
      insert_into_file(
        'app/assets/stylesheets/application.sass',
        "\n@import devise",
        after: '@import layout'
      )
    end

    def setup_devise_spec_support
      copy_file "devise_spec_support.rb", "spec/support/devise.rb"
    end

    def add_auth_links_to_nav
      append_to_file 'app/views/layouts/_nav.haml', <<-HAML
  .float-right
    - if current_user
      %li= link_to "Log out", destroy_user_session_path
    - else
      %li= link_to "Sign up", new_user_registration_path
      %li= link_to "Log in", new_user_session_path
      HAML
    end

    def generate_user_model
      generate "devise User"
    end

    def add_admin_to_user_model
      generate "migration add_admin_to_users admin:boolean"
      admin_migration = Dir['db/migrate/*'].first
      gsub_file admin_migration, "add_column :users, :admin, :boolean", "add_column :users, :admin, :boolean, default: false, null: false"
      bundle_command 'exec rake db:migrate'
    end

    def add_admin_methods_to_application_controller
      insert_into_file 'app/controllers/application_controller.rb', after: "protect_from_forgery with: :exception\n" do
        <<-RUBY

  def current_admin
    current_user.try(:admin?) ? current_user : nil
  end
  helper_method :current_admin

  def require_admin
    render_not_authorized unless current_admin
  end

  def render_not_authorized
    flash[:alert] = 'Not authorized'
    if request.referrer
      #Rollbar.error "User clicked a link that shouldn't have been visible to them. Fix this."
      redirect_to request.referrer
    elsif current_user
      redirect_to after_sign_in_path_for(current_user)
    else
      redirect_to root_path
    end
  end
        RUBY
      end
      copy_file 'application_controller_spec.rb', 'spec/controllers/application_controller_spec.rb'
    end

    def setup_users_factory
      copy_file 'users_factory.rb', 'spec/factories/users_factory.rb', force: true
    end

    def configure_devise_routes
      gsub_file 'config/routes.rb', "devise_for :users", "devise_for :users, path: 'auth'\n"
    end

    def copy_archivable_concern_and_spec
      copy_file 'archivable.rb', 'app/models/concerns/archivable.rb'
      copy_file 'archivable_shared_examples.rb', 'spec/shared_examples/archivable_shared_examples.rb'
    end

    def add_archivable_to_user
      generate 'migration add_archived_at_to_users archived_at:datetime'
      rake 'db:migrate'
      insert_into_file(
        'app/models/user.rb',
        "  include Archivable\n\n",
        after: "class User < ActiveRecord::Base\n"
      )
      insert_into_file(
        'spec/models/user_spec.rb',
        "  it_behaves_like Archivable\n",
        after: "RSpec.describe User do\n"
      )
      gsub_file 'config/locales/devise.en.yml', 'Your account is not activated yet.', 'Your account is not active.'
    end

    def stop_archived_users_from_signing_in
      insert_into_file 'app/models/user.rb', after: " :recoverable, :rememberable, :trackable, :validatable\n" do
        <<-TEXT

  # Devise

  def active_for_authentication?
    super && !archived?
  end
        TEXT
      end
    end

    def copy_auth_token_concern_and_spec
      copy_file 'auth_token_authenticatable.rb', 'app/models/concerns/auth_token_authenticatable.rb'
    end

    def setup_delayed_job
      generate 'delayed_job:active_record'
      bundle_command 'exec rake db:migrate'
      create_file 'config/initializers/delayed_job.rb' do
        <<-TEXT
Rails.application.config.active_job.queue_adapter = :delayed_job
Delayed::Worker.logger = Logger.new(File.join(Rails.root, 'log', "\#{Rails.env}_delayed_job.log"))
        TEXT
      end
    end

    def install_capistrano
      bundle_command 'exec cap install STAGES=dev,production'
    end

    def configure_deploys
      copy_file 'deploy_dev.rb', 'config/deploy/dev.rb', force: true
      copy_file 'deploy_production.rb', 'config/deploy/production.rb', force: true
      template 'deploy.rb.erb', 'config/deploy.rb', force: true
    end

    def setup_dev_environments_file
      run 'cp config/environments/production.rb config/environments/dev.rb'
      gsub_file 'config/environments/dev.rb', 'config.consider_all_requests_local       = false', 'config.consider_all_requests_local       = true'
    end

    def configure_capfile
      append_to_file 'Capfile', "\nrequire 'jefferies_tube/capistrano'"
      gsub_file 'Capfile', "# require 'capistrano/rails/assets'\n# require 'capistrano/rails/migrations'", "require 'capistrano/rails'"
      gsub_file 'Capfile', "# require 'capistrano/passenger'", "require 'capistrano/passenger'"
    end

    def setup_git
      append_to_file '.gitignore', "\nconfig/application.yml\nconfig/database.yml"
      run 'git init'
    end

    private

    def raise_on_missing_translations_in(environment)
      config = 'config.action_view.raise_on_missing_translations = true'
      uncomment_lines("config/environments/#{environment}.rb", config)
    end
  end
end
