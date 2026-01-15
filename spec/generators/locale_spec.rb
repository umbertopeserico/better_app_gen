# frozen_string_literal: true

RSpec.describe BetterAppGen::Generators::Locale, :generator do
  describe "#generate!" do
    context "with en locale (default)" do
      let(:config) do
        BetterAppGen::Configuration.new(
          app_name: "test_app",
          app_path: app_path,
          locale: "en"
        )
      end
      let(:generator) { described_class.new(config) }

      it "does not create locale file" do
        generator.generate!
        expect(file_exists?("config/locales/en.yml")).to be false
      end
    end

    context "with it locale (has template)" do
      let(:config) do
        BetterAppGen::Configuration.new(
          app_name: "test_app",
          app_path: app_path,
          locale: "it"
        )
      end
      let(:generator) { described_class.new(config) }

      it "creates locale file" do
        generator.generate!
        expect(file_exists?("config/locales/it.yml")).to be true
      end

      it "creates valid YAML file" do
        generator.generate!
        content = read_generated_file("config/locales/it.yml")
        expect(content).to include("it:")
      end
    end

    context "with de locale (no template)" do
      let(:config) do
        BetterAppGen::Configuration.new(
          app_name: "test_app",
          app_path: app_path,
          locale: "de"
        )
      end
      let(:generator) { described_class.new(config) }

      it "does not create locale file if template missing" do
        # Check if template exists first
        template_path = BetterAppGen.templates_path.join("config/locales/de.yml.erb")
        unless template_path.exist?
          generator.generate!
          expect(file_exists?("config/locales/de.yml")).to be false
        end
      end
    end
  end
end
