# frozen_string_literal: true

RSpec.describe BetterAppGen::Generators::SolidStack, :generator do
  let(:generator) { described_class.new(config) }

  describe "#generate!" do
    it "creates config/application.rb" do
      generator.generate!
      expect(file_exists?("config/application.rb")).to be true
    end

    it "creates valid Ruby file" do
      generator.generate!
      content = read_generated_file("config/application.rb")
      expect(content).to include("module")
      expect(content).to include("Application")
    end

    it "includes Solid Stack configuration" do
      generator.generate!
      content = read_generated_file("config/application.rb")
      # The template should configure solid_cache, solid_queue, solid_cable
      expect(content).to include("config")
    end

    it "uses app_name_pascal for module name" do
      generator.generate!
      content = read_generated_file("config/application.rb")
      expect(content).to include("TestApp")
    end
  end
end
