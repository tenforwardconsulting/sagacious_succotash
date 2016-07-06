RSpec.describe 'Configuring Pundit' do
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
