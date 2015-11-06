require 'spec_helper'

RSpec.describe "Creating a new project" do
  before(:all) do
    drop_dummy_database
    remove_project_directory
    run_sagacious_succotash
  end

  it 'configures simple form' do
    expect(File).to exist "#{project_path}/config/initializers/simple_form.rb"
  end
end
