RSpec.describe "Devise configuration" do
  it 'configures the devise intializer' do
    file = File.read "#{project_path}/config/initializers/devise.rb"
    expect(file).to include <<-CODE
  # Set parent mailer so devise will have ApplicationMailer settings.
  config.parent_mailer = 'ApplicationMailer'
    CODE

    expect(file).to include <<-CODE
  config.password_length = 6..128
    CODE

    expect(file).to include <<-CODE
  config.sign_out_via = [:delete, :get]
    CODE
  end

  it "changes the ApplicationMailer's default from to be the same as the Devise sender" do
    expect(File.read "#{project_path}/app/mailers/application_mailer.rb").to include <<-CODE
  default from: 'Devise.mailer_sender'
    CODE
  end

  it "adds devise stylesheet to app/assets/stylesheets/application.sass" do
    expect(File.read "#{project_path}/app/assets/stylesheets/application.sass").to include <<-CODE
@import devise
    CODE
  end
end
