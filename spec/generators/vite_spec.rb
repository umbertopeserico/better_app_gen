# frozen_string_literal: true

RSpec.describe BetterAppGen::Generators::Vite, :generator do
  let(:generator) { described_class.new(config) }

  describe "constants" do
    it "defines DEPENDENCIES with Stimulus and Turbo" do
      expect(described_class::DEPENDENCIES).to include("@hotwired/stimulus")
      expect(described_class::DEPENDENCIES).to include("@hotwired/turbo-rails")
    end

    it "defines DEV_DEPENDENCIES with Tailwind and Vite" do
      expect(described_class::DEV_DEPENDENCIES).to include("tailwindcss")
      expect(described_class::DEV_DEPENDENCIES).to include("vite")
      expect(described_class::DEV_DEPENDENCIES).to include("postcss")
    end

    it "defines SCRIPTS for dev and build" do
      expect(described_class::SCRIPTS).to include("dev")
      expect(described_class::SCRIPTS).to include("build")
    end
  end

  describe "#generate!" do
    before { generator.generate! }

    describe "directories" do
      it "creates app/assets/images directory" do
        expect(File.directory?(file_path("app/assets/images"))).to be true
      end

      it "creates app/assets/javascripts/controllers directory" do
        expect(File.directory?(file_path("app/assets/javascripts/controllers"))).to be true
      end

      it "creates app/assets/stylesheets directory" do
        expect(File.directory?(file_path("app/assets/stylesheets"))).to be true
      end
    end

    describe "package.json" do
      it "creates package.json" do
        expect(file_exists?("package.json")).to be true
      end

      it "includes dependencies" do
        data = JSON.parse(read_generated_file("package.json"))
        expect(data["dependencies"]).to include("@hotwired/stimulus")
      end

      it "includes devDependencies" do
        data = JSON.parse(read_generated_file("package.json"))
        expect(data["devDependencies"]).to include("vite")
        expect(data["devDependencies"]).to include("tailwindcss")
      end

      it "includes scripts with correct port" do
        data = JSON.parse(read_generated_file("package.json"))
        expect(data["scripts"]["dev"]).to include(config.vite_port.to_s)
      end

      it "sets type to module" do
        data = JSON.parse(read_generated_file("package.json"))
        expect(data["type"]).to eq("module")
      end
    end

    describe "vite config" do
      it "creates vite.config.js" do
        expect(file_exists?("vite.config.js")).to be true
      end

      it "contains Vite configuration" do
        content = read_generated_file("vite.config.js")
        expect(content).to include("vite")
      end
    end

    describe "PostCSS config" do
      it "creates postcss.config.js" do
        expect(file_exists?("postcss.config.js")).to be true
      end
    end

    describe "stylesheets" do
      it "creates application.css" do
        expect(file_exists?("app/assets/stylesheets/application.css")).to be true
      end

      it "includes Tailwind" do
        content = read_generated_file("app/assets/stylesheets/application.css")
        expect(content).to include("tailwind")
      end
    end

    describe "JavaScript files" do
      it "creates application.js" do
        expect(file_exists?("app/assets/javascripts/application.js")).to be true
      end

      it "creates controllers/application.js" do
        expect(file_exists?("app/assets/javascripts/controllers/application.js")).to be true
      end

      it "creates controllers/hello_controller.js" do
        expect(file_exists?("app/assets/javascripts/controllers/hello_controller.js")).to be true
      end

      it "creates controllers/index.js" do
        expect(file_exists?("app/assets/javascripts/controllers/index.js")).to be true
      end
    end

    describe "Vite helper" do
      it "creates vite_helper.rb" do
        expect(file_exists?("app/helpers/vite_helper.rb")).to be true
      end

      it "defines ViteHelper module" do
        content = read_generated_file("app/helpers/vite_helper.rb")
        expect(content).to include("module ViteHelper")
      end
    end

    describe "Procfile.dev" do
      it "creates Procfile.dev" do
        expect(file_exists?("Procfile.dev")).to be true
      end

      it "contains process definitions" do
        content = read_generated_file("Procfile.dev")
        expect(content).to include(":")
      end
    end

    describe "bin/dev" do
      it "creates bin/dev" do
        expect(file_exists?("bin/dev")).to be true
      end

      it "is executable" do
        expect(File.executable?(file_path("bin/dev"))).to be true
      end
    end

    describe "yarnrc" do
      it "creates .yarnrc.yml" do
        expect(file_exists?(".yarnrc.yml")).to be true
      end
    end

    describe "gitignore" do
      it "creates .gitignore" do
        expect(file_exists?(".gitignore")).to be true
      end
    end

    describe "env files" do
      it "creates .env.example" do
        expect(file_exists?(".env.example")).to be true
      end

      it "creates .env" do
        expect(file_exists?(".env")).to be true
      end
    end

    describe "layout" do
      it "creates application.html.erb" do
        expect(file_exists?("app/views/layouts/application.html.erb")).to be true
      end

      it "includes Vite tags" do
        content = read_generated_file("app/views/layouts/application.html.erb")
        expect(content).to include("vite")
      end
    end
  end

  describe "removes default CSS" do
    it "removes application.css if exists" do
      # Create default CSS before running generator
      css_path = file_path("app/assets/stylesheets/application.css")
      FileUtils.mkdir_p(File.dirname(css_path))
      File.write(css_path, "/* default rails css */")

      generator.generate!

      # New file should be created with Tailwind content
      content = File.read(css_path)
      expect(content).to include("tailwind")
    end
  end
end
