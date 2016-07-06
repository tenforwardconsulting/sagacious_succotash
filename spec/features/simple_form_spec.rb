RSpec.describe 'Configuring SimpleForm' do
  it 'configures simple form' do
    expect(File).to exist "#{project_path}/config/initializers/simple_form.rb"
  end
end
