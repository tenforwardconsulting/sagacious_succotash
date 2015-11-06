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
  end
end
