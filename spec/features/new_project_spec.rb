require 'spec_helper'

RSpec.describe "Creating a new project" do
  before(:all) do
    # You can run this here, but I usually prefer to run it separately before
    # running the specs and leave it commented out.
    # I'm still not sure the best way to do testing.
    #`./bin/test`
  end

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
end
