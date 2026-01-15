# frozen_string_literal: true

RSpec.describe BetterAppGen::Generators::SimpleForm, :generator do
  describe "#generate!" do
    context "with en locale" do
      let(:config) do
        BetterAppGen::Configuration.new(
          app_name: "test_app",
          app_path: app_path,
          locale: "en",
          with_simple_form: true
        )
      end
      let(:generator) { described_class.new(config) }

      it "creates simple_form initializer" do
        generator.generate!
        expect(file_exists?("config/initializers/simple_form.rb")).to be true
      end

      it "creates valid Ruby initializer" do
        generator.generate!
        content = read_generated_file("config/initializers/simple_form.rb")
        expect(content).to include("SimpleForm")
      end

      it "does not create locale file for en" do
        generator.generate!
        expect(file_exists?("config/locales/simple_form.en.yml")).to be false
      end
    end

    context "with it locale" do
      let(:config) do
        BetterAppGen::Configuration.new(
          app_name: "test_app",
          app_path: app_path,
          locale: "it",
          with_simple_form: true
        )
      end
      let(:generator) { described_class.new(config) }

      it "creates simple_form initializer" do
        generator.generate!
        expect(file_exists?("config/initializers/simple_form.rb")).to be true
      end

      it "creates locale file if template exists" do
        template_path = BetterAppGen.templates_path.join("config/locales/simple_form.it.yml.erb")
        generator.generate!
        if template_path.exist?
          expect(file_exists?("config/locales/simple_form.it.yml")).to be true
        else
          # Template doesn't exist, skip test
          expect(file_exists?("config/locales/simple_form.it.yml")).to be false
        end
      end
    end

    context "with locale without template" do
      let(:config) do
        BetterAppGen::Configuration.new(
          app_name: "test_app",
          app_path: app_path,
          locale: "ja",
          with_simple_form: true
        )
      end
      let(:generator) { described_class.new(config) }

      it "creates initializer but not locale file" do
        generator.generate!
        expect(file_exists?("config/initializers/simple_form.rb")).to be true
        expect(file_exists?("config/locales/simple_form.ja.yml")).to be false
      end
    end
  end
end
