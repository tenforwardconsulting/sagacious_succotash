require 'pathname'

module FeatureHelpers
  APP_NAME = "dummy_app"

  def create_tmp_directory
    FileUtils.mkdir_p(tmp_path)
  end

  def project_path
    @project_path ||= Pathname.new("#{tmp_path}/#{APP_NAME}")
  end

  private

  def tmp_path
    @tmp_path ||= Pathname.new("#{root_path}/tmp")
  end

  def sagacious_succotash_bin
    File.join(root_path, 'bin', 'sagacious_succotash')
  end

  def root_path
    File.expand_path('../../../', __FILE__)
  end
end

RSpec.configure do |config|
  config.include FeatureHelpers
end
