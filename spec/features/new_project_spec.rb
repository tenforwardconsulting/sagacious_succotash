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
end
