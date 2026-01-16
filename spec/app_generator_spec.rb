# frozen_string_literal: true

RSpec.describe BetterAppGen::AppGenerator, :generator do
  let(:generator) { described_class.new(config) }

  # Mock all individual generators to avoid actually running them
  let(:mock_rails_app) { instance_double(BetterAppGen::Generators::RailsApp) }
  let(:mock_gemfile) { instance_double(BetterAppGen::Generators::Gemfile) }
  let(:mock_database) { instance_double(BetterAppGen::Generators::Database) }
  let(:mock_solid_stack) { instance_double(BetterAppGen::Generators::SolidStack) }
  let(:mock_vite) { instance_double(BetterAppGen::Generators::Vite) }
  let(:mock_home_controller) { instance_double(BetterAppGen::Generators::HomeController) }
  let(:mock_locale) { instance_double(BetterAppGen::Generators::Locale) }
  let(:mock_docker) { instance_double(BetterAppGen::Generators::Docker) }
  let(:mock_simple_form) { instance_double(BetterAppGen::Generators::SimpleForm) }

  before do
    # Stub all generator classes
    allow(BetterAppGen::Generators::RailsApp).to receive(:new).and_return(mock_rails_app)
    allow(BetterAppGen::Generators::Gemfile).to receive(:new).and_return(mock_gemfile)
    allow(BetterAppGen::Generators::Database).to receive(:new).and_return(mock_database)
    allow(BetterAppGen::Generators::SolidStack).to receive(:new).and_return(mock_solid_stack)
    allow(BetterAppGen::Generators::Vite).to receive(:new).and_return(mock_vite)
    allow(BetterAppGen::Generators::HomeController).to receive(:new).and_return(mock_home_controller)
    allow(BetterAppGen::Generators::Locale).to receive(:new).and_return(mock_locale)
    allow(BetterAppGen::Generators::Docker).to receive(:new).and_return(mock_docker)
    allow(BetterAppGen::Generators::SimpleForm).to receive(:new).and_return(mock_simple_form)

    # Allow generate! on all mocks
    allow(mock_rails_app).to receive(:generate!)
    allow(mock_gemfile).to receive(:generate!)
    allow(mock_database).to receive(:generate!)
    allow(mock_solid_stack).to receive(:generate!)
    allow(mock_vite).to receive(:generate!)
    allow(mock_home_controller).to receive(:generate!)
    allow(mock_locale).to receive(:generate!)
    allow(mock_docker).to receive(:generate!)
    allow(mock_simple_form).to receive(:generate!)

    # Stub post-generation tasks
    allow(generator).to receive(:system).and_return(true)
    allow(Dir).to receive(:chdir).and_yield
  end

  describe "#initialize" do
    it "stores the config" do
      expect(generator.config).to eq(config)
    end

    it "creates a pastel instance" do
      expect(generator.pastel).to respond_to(:green)
    end
  end

  describe "#generate!" do
    it "runs RailsApp generator" do
      generator.generate!
      expect(mock_rails_app).to have_received(:generate!)
    end

    it "runs Gemfile generator" do
      generator.generate!
      expect(mock_gemfile).to have_received(:generate!)
    end

    it "runs Database generator" do
      generator.generate!
      expect(mock_database).to have_received(:generate!)
    end

    it "runs SolidStack generator" do
      generator.generate!
      expect(mock_solid_stack).to have_received(:generate!)
    end

    it "runs Vite generator" do
      generator.generate!
      expect(mock_vite).to have_received(:generate!)
    end

    it "runs HomeController generator" do
      generator.generate!
      expect(mock_home_controller).to have_received(:generate!)
    end

    it "runs Locale generator" do
      generator.generate!
      expect(mock_locale).to have_received(:generate!)
    end

    context "with Docker enabled (default)" do
      let(:config) do
        BetterAppGen::Configuration.new(
          app_name: "test_app",
          app_path: app_path,
          skip_docker: false
        )
      end

      it "runs Docker generator" do
        generator.generate!
        expect(mock_docker).to have_received(:generate!)
      end
    end

    context "with Docker disabled" do
      let(:config) do
        BetterAppGen::Configuration.new(
          app_name: "test_app",
          app_path: app_path,
          skip_docker: true
        )
      end

      it "skips Docker generator" do
        generator.generate!
        expect(mock_docker).not_to have_received(:generate!)
      end
    end

    context "with SimpleForm enabled" do
      let(:config) do
        BetterAppGen::Configuration.new(
          app_name: "test_app",
          app_path: app_path,
          with_simple_form: true
        )
      end

      it "runs SimpleForm generator" do
        generator.generate!
        expect(mock_simple_form).to have_received(:generate!)
      end
    end

    context "with SimpleForm disabled (default)" do
      let(:config) do
        BetterAppGen::Configuration.new(
          app_name: "test_app",
          app_path: app_path,
          with_simple_form: false
        )
      end

      it "skips SimpleForm generator" do
        generator.generate!
        expect(mock_simple_form).not_to have_received(:generate!)
      end
    end

    it "runs generators in correct order" do
      order = []
      allow(mock_rails_app).to receive(:generate!) { order << :rails_app }
      allow(mock_gemfile).to receive(:generate!) { order << :gemfile }
      allow(mock_database).to receive(:generate!) { order << :database }
      allow(mock_solid_stack).to receive(:generate!) { order << :solid_stack }
      allow(mock_vite).to receive(:generate!) { order << :vite }
      allow(mock_home_controller).to receive(:generate!) { order << :home_controller }
      allow(mock_locale).to receive(:generate!) { order << :locale }
      allow(mock_docker).to receive(:generate!) { order << :docker }

      generator.generate!

      expected_order = %i[rails_app gemfile database solid_stack vite home_controller locale docker]
      expect(order).to eq(expected_order)
    end
  end

  describe "error handling" do
    it "propagates errors from generators" do
      allow(mock_rails_app).to receive(:generate!).and_raise(BetterAppGen::RailsGenerationError.new)

      expect { generator.generate! }.to raise_error(BetterAppGen::RailsGenerationError)
    end
  end
end
