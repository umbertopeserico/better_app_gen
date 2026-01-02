# frozen_string_literal: true

RSpec.describe BetterAppgen::Configuration do
  describe "#initialize" do
    it "creates a valid configuration with default values" do
      config = described_class.new(app_name: "my-app")

      expect(config.app_name).to eq("my-app")
      expect(config.rails_port).to eq(3000)
      expect(config.vite_port).to eq(5173)
      expect(config.locale).to eq("en")
      expect(config.with_simple_form).to be false
      expect(config.skip_docker).to be false
    end

    it "accepts custom options" do
      config = described_class.new(
        app_name: "test-app",
        rails_port: 4000,
        vite_port: 5174,
        locale: "it",
        with_simple_form: true,
        skip_docker: true
      )

      expect(config.rails_port).to eq(4000)
      expect(config.vite_port).to eq(5174)
      expect(config.locale).to eq("it")
      expect(config.with_simple_form).to be true
      expect(config.skip_docker).to be true
    end

    context "with invalid app name" do
      it "raises InvalidAppNameError for names starting with number" do
        expect { described_class.new(app_name: "123app") }
          .to raise_error(BetterAppgen::InvalidAppNameError)
      end

      it "raises InvalidAppNameError for names with special characters" do
        expect { described_class.new(app_name: "my@app") }
          .to raise_error(BetterAppgen::InvalidAppNameError)
      end
    end

    context "with invalid locale" do
      it "raises Error for unsupported locale" do
        expect { described_class.new(app_name: "my-app", locale: "xx") }
          .to raise_error(BetterAppgen::Error, /Unsupported locale/)
      end
    end

    context "with invalid ports" do
      it "raises Error for port below 1024" do
        expect { described_class.new(app_name: "my-app", rails_port: 80) }
          .to raise_error(BetterAppgen::Error, /Rails port must be between/)
      end

      it "raises Error when ports are the same" do
        expect { described_class.new(app_name: "my-app", rails_port: 3000, vite_port: 3000) }
          .to raise_error(BetterAppgen::Error, /must be different/)
      end
    end
  end

  describe "#app_name_snake" do
    it "converts dashes to underscores" do
      config = described_class.new(app_name: "my-awesome-app")
      expect(config.app_name_snake).to eq("my_awesome_app")
    end
  end

  describe "#app_name_pascal" do
    it "converts to PascalCase" do
      config = described_class.new(app_name: "my-awesome-app")
      expect(config.app_name_pascal).to eq("MyAwesomeApp")
    end
  end

  describe "#app_name_dash" do
    it "converts underscores to dashes" do
      config = described_class.new(app_name: "my_awesome_app")
      expect(config.app_name_dash).to eq("my-awesome-app")
    end
  end

  describe "#timezone" do
    it "returns correct timezone for Italian locale" do
      config = described_class.new(app_name: "my-app", locale: "it")
      expect(config.timezone).to eq("Europe/Rome")
    end

    it "returns UTC for English locale" do
      config = described_class.new(app_name: "my-app", locale: "en")
      expect(config.timezone).to eq("UTC")
    end

    it "returns correct timezone for Japanese locale" do
      config = described_class.new(app_name: "my-app", locale: "ja")
      expect(config.timezone).to eq("Asia/Tokyo")
    end
  end
end
