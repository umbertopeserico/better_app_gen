# frozen_string_literal: true

RSpec.describe BetterAppGen::Generators::Gemfile, :generator do
  let(:generator) { described_class.new(config) }

  before do
    create_test_file("Gemfile", <<~GEMFILE)
      source "https://rubygems.org"
      gem "rails"

      group :development do
        gem "debug"
      end
    GEMFILE
  end

  describe "constants" do
    it "defines SOLID_GEMS" do
      expect(described_class::SOLID_GEMS).to include('gem "solid_cache"')
      expect(described_class::SOLID_GEMS).to include('gem "solid_queue"')
      expect(described_class::SOLID_GEMS).to include('gem "solid_cable"')
    end

    it "defines BASE_GEMS" do
      expect(described_class::BASE_GEMS).to include('gem "rails-i18n"')
    end
  end

  describe "#generate!" do
    it "adds solid_cache gem" do
      generator.generate!
      content = read_generated_file("Gemfile")
      expect(content).to include('gem "solid_cache"')
    end

    it "adds solid_queue gem" do
      generator.generate!
      content = read_generated_file("Gemfile")
      expect(content).to include('gem "solid_queue"')
    end

    it "adds solid_cable gem" do
      generator.generate!
      content = read_generated_file("Gemfile")
      expect(content).to include('gem "solid_cable"')
    end

    it "adds rails-i18n gem" do
      generator.generate!
      content = read_generated_file("Gemfile")
      expect(content).to include('gem "rails-i18n"')
    end

    context "without simple_form" do
      let(:config) do
        BetterAppGen::Configuration.new(
          app_name: "test_app",
          app_path: app_path,
          with_simple_form: false
        )
      end

      it "does not add simple_form gem" do
        generator.generate!
        content = read_generated_file("Gemfile")
        expect(content).not_to include('gem "simple_form"')
      end
    end

    context "with simple_form" do
      let(:config) do
        BetterAppGen::Configuration.new(
          app_name: "test_app",
          app_path: app_path,
          with_simple_form: true
        )
      end

      it "adds simple_form gem" do
        generator.generate!
        content = read_generated_file("Gemfile")
        expect(content).to include('gem "simple_form"')
      end
    end

    it "does not duplicate gems on multiple runs" do
      generator.generate!
      generator.generate!
      content = read_generated_file("Gemfile")
      expect(content.scan('gem "solid_cache"').count).to eq(1)
    end
  end
end
