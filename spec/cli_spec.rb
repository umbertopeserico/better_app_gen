# frozen_string_literal: true

RSpec.describe BetterAppGen::CLI do
  describe ".exit_on_failure?" do
    it "returns true" do
      expect(described_class.exit_on_failure?).to be true
    end
  end

  describe "#version" do
    it "outputs the version" do
      expect { described_class.new.version }
        .to output("better_app_gen v#{BetterAppGen::VERSION}\n").to_stdout
    end
  end

  describe "LOCALES_WITH_TEMPLATES" do
    it "includes en and it" do
      expect(described_class::LOCALES_WITH_TEMPLATES).to include("en")
      expect(described_class::LOCALES_WITH_TEMPLATES).to include("it")
    end
  end

  describe "#check" do
    let(:cli) { described_class.new }

    it "outputs checking message" do
      expect { cli.check }.to output(/Checking dependencies/).to_stdout
    end

    it "shows dependency status" do
      expect { cli.check }.to output(/ruby|rails|node/).to_stdout
    end
  end

  describe "#new" do
    let(:cli) { described_class.new }
    let(:mock_generator) { instance_double(BetterAppGen::AppGenerator) }
    let(:mock_checker) { instance_double(BetterAppGen::DependencyChecker) }

    before do
      allow(BetterAppGen::DependencyChecker).to receive(:new).and_return(mock_checker)
      allow(mock_checker).to receive_messages(check_all: true, missing_dependencies: [])

      allow(BetterAppGen::AppGenerator).to receive(:new).and_return(mock_generator)
      allow(mock_generator).to receive(:generate!)
    end

    context "with invalid app name" do
      it "exits with error for app name starting with number" do
        expect { cli.invoke(:new, ["123app"]) }.to raise_error(SystemExit)
      end
    end

    context "when directory exists" do
      it "exits with error" do
        Dir.mktmpdir do |dir|
          existing_app = File.join(dir, "existing_app")
          FileUtils.mkdir_p(existing_app)

          Dir.chdir(dir) do
            expect { cli.invoke(:new, ["existing_app"]) }.to raise_error(SystemExit)
          end
        end
      end
    end

    context "when dependencies are missing" do
      before do
        allow(mock_checker).to receive_messages(check_all: false, missing_dependencies: ["node"])
      end

      it "exits with error" do
        Dir.mktmpdir do |dir|
          Dir.chdir(dir) do
            expect { cli.invoke(:new, ["new_app"]) }.to raise_error(SystemExit)
          end
        end
      end
    end

    context "with valid app name and all dependencies" do
      it "creates the application" do
        Dir.mktmpdir do |dir|
          Dir.chdir(dir) do
            expect(mock_generator).to receive(:generate!)
            expect { cli.invoke(:new, ["valid_app"]) }.to output(/created successfully/).to_stdout
          end
        end
      end

      it "shows next steps for Docker mode" do
        Dir.mktmpdir do |dir|
          Dir.chdir(dir) do
            expect { cli.invoke(:new, ["docker_app"]) }.to output(/dc-up/).to_stdout
          end
        end
      end

      it "shows next steps for non-Docker mode" do
        cli.options = { skip_docker: true, rails_port: 3000, vite_port: 5173, locale: "en", with_simple_form: false }
        Dir.mktmpdir do |dir|
          Dir.chdir(dir) do
            # Use direct invocation with options
            expect { cli.invoke(:new, ["non_docker_app"], skip_docker: true) }
              .to output(/bundle install/).to_stdout
          end
        end
      end
    end

    context "with locale without templates" do
      it "warns about missing translation files" do
        cli.options = { locale: "de", rails_port: 3000, vite_port: 5173, skip_docker: false, with_simple_form: false }
        Dir.mktmpdir do |dir|
          Dir.chdir(dir) do
            expect { cli.invoke(:new, ["german_app"], locale: "de") }
              .to output(/does not include translation files/).to_stdout
          end
        end
      end
    end
  end
end
