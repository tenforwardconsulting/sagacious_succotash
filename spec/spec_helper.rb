$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'sagacious_succotash'
Dir['./spec/support/**/*.rb'].each { |file| require file }

RSpec.configure do |config|
  config.before(:all) do
    create_tmp_directory
  end
end
