RSpec.describe "Configuring mailer settings" do
  it 'configures mailer in development' do
    file = File.read "#{project_path}/config/environments/development.rb"
    expect(file).to include <<-CODE
  # Raise error if the mailer can't send.
  config.action_mailer.raise_delivery_errors = true

  # Open emails with letter_opener.
  config.action_mailer.delivery_method = :letter_opener

  # Send emails.
  config.action_mailer.perform_deliveries = true

  # Set email host.
  config.action_mailer.default_url_options = { host: 'localhost', port: 3000 }
    CODE
  end

  it 'adds keys to application.yml.example' do
    file = File.read "#{project_path}/config/application.yml.example"
    expect(file).to include 'MANDRILL_USERNAME:'
    expect(file).to include 'MANDRILL_PASSWORD:'
  end

end
