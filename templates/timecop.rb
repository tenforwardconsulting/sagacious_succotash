RSpec.configure do |config|
  # Usage:
  # In an rspec file
  #
  #     describe 'foobar', timecop: :freeze do
  #       ...
  #     end
  #
  # is shorthand for
  #
  #     describe 'foobar' do
  #       Timecop.freeze
  #       ...
  #       Timecop.return
  #     end
  config.before :each, timecop: :freeze do
    Timecop.freeze
  end

  config.after :each, timecop: :freeze do
    Timecop.return
  end
end
