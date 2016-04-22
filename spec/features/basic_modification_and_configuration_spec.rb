RSpec.describe "Basic modification and configuration" do
  it 'sets project name in README.md' do
    file = File.read "#{project_path}/README.md"
    expect(file).to include "# Dummy App"
  end

  it 'creates a .ruby-version file' do
    expect(File).to exist "#{project_path}/.ruby-version"
    expect(File.read "#{project_path}/.ruby-version").to eq "#{SagaciousSuccotash::RUBY_VERSION}\n"
  end

  it 'creates a .ruby-gemset file' do
    expect(File).to exist "#{project_path}/.ruby-gemset"
    expect(File.read "#{project_path}/.ruby-gemset").to eq "dummy_app\n"
  end

  it 'configures config/environments/development.rb' do
    file = File.read "#{project_path}/config/environments/development.rb"
    expect(file).to include <<-CODE
  # Raises error for missing translations
  config.action_view.raise_on_missing_translations = true
    CODE
  end

  it 'configures config/environments/test.rb' do
    file = File.read "#{project_path}/config/environments/test.rb"
    expect(file).to include <<-CODE
  # Raises error for missing translations
  config.action_view.raise_on_missing_translations = true
    CODE
  end

  it 'configures config/application.rb' do
    expect(File.read "#{project_path}/config/application.rb").to include <<-CODE
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

    # Use .sass instead of .scss.
    config.sass.preferred_syntax = :sass

    # Raise an error for unpermitted parameters.
    config.action_controller.action_on_unpermitted_parameters = :raise
    CODE
  end

  it 'sets project name in application layout title' do
    file = File.read "#{project_path}/app/views/layouts/application.html.haml"
    expect(file).to include "%title Dummy App"
  end

  it 'configures app/assets/javascripts/application.js' do
    file = File.read "#{project_path}/app/assets/javascripts/application.js"
    expect(file).to include <<-CODE
//= require jquery
//= require jquery_ujs
//= require_self
//= require_tree .

window.DummyApp = {};
    CODE
  end

  it 'adds HomeController to routes' do
    expect(File.read "#{project_path}/config/routes.rb").to include "root to: 'home#show'"
  end
end
