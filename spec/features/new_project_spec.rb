require 'spec_helper'

RSpec.describe "Creating a new project" do
  it 'sets project name in README.md' do
    file = File.read "#{project_path}/README.md"
    expect(file).to include "# Dummy App"
  end

  it 'sets project name in application layout title' do
    file = File.read "#{project_path}/app/views/layouts/application.html.haml"
    expect(file).to include "%title Dummy App"
  end

  it 'configures simple form' do
    expect(File).to exist "#{project_path}/config/initializers/simple_form.rb"
  end

  context 'pundit' do
    it 'adds ApplicationPolicy' do
      expect(File).to exist "#{project_path}/app/policies/application_policy.rb"
    end

    it 'configures ApplicationController' do
      file = File.read "#{project_path}/app/controllers/application_controller.rb"
      expect(file).to include <<-CODE.strip_heredoc
        class ApplicationController < ActionController::Base
          # Enable Pundit
          include Pundit
          # Force authorization be used
          after_action :verify_authorized, except: :index, unless: :devise_controller?
          after_action :verify_policy_scoped, only: :index, unless: :devise_controller?
      CODE
    end

    it 'configures HomeController' do
      file = File.read "#{project_path}/app/controllers/home_controller.rb"
      expect(file).to include <<-CODE.strip_heredoc
        class HomeController < ApplicationController
          before_action :skip_authorization
      CODE
    end

    it 'adds ModelPolicy shared examples' do
      expect(File).to exist "#{project_path}/spec/shared_examples/model_policy_shared_examples.rb"
    end
  end

  context 'mailer settings' do
    let(:code) { <<-CODE.strip_heredoc

          # Mailer config
          config.action_mailer.perform_deliveries = true
          config.action_mailer.default_url_options = { host: 'something'}
          config.action_mailer.asset_host = 'something'
          config.action_mailer.smtp_settings = {
            :address   => "smtp.mandrillapp.com",
            :port      => 25,                       # ports 587 and 2525 are also supported with STARTTLS
            :enable_starttls_auto => true,          # detects and uses STARTTLS
            :user_name => ENV["MANDRILL_USERNAME"],
            :password  => ENV["MANDRILL_PASSWORD"], # SMTP password is any valid API key
            :authentication => 'login',             # Mandrill supports 'plain' or 'login'
            :domain => 'something',                 # your domain to identify your server when connecting
          }
        end
      CODE
    }

    it 'adds mailer config to config/environments/production.rb' do
      file = File.read "#{project_path}/config/environments/production.rb"
      expect(file).to end_with code
    end

    it 'adds mailer config to config/environments/dev.rb' do
      file = File.read "#{project_path}/config/environments/dev.rb"
      expect(file).to end_with code
    end

    it 'adds keys to application.yml.example' do
      file = File.read "#{project_path}/config/application.yml.example"
      expect(file).to include 'MANDRILL_USERNAME:'
      expect(file).to include 'MANDRILL_PASSWORD:'
    end
  end
end
