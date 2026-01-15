# frozen_string_literal: true

require "tmpdir"
require "fileutils"

RSpec.shared_context "generator setup" do
  let(:tmp_dir) { Dir.mktmpdir }
  let(:app_path) { File.join(tmp_dir, "test_app") }
  let(:config) do
    BetterAppGen::Configuration.new(
      app_name: "test_app",
      app_path: app_path
    )
  end

  before do
    FileUtils.mkdir_p(app_path)
  end

  after do
    FileUtils.rm_rf(tmp_dir)
  end

  def file_path(relative_path)
    File.join(app_path, relative_path)
  end

  def read_generated_file(relative_path)
    File.read(file_path(relative_path))
  end

  def file_exists?(relative_path)
    File.exist?(file_path(relative_path))
  end

  def create_test_file(relative_path, content)
    full_path = file_path(relative_path)
    FileUtils.mkdir_p(File.dirname(full_path))
    File.write(full_path, content)
  end
end

RSpec.configure do |config|
  config.include_context "generator setup", :generator
end
