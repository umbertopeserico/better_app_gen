# frozen_string_literal: true

RSpec.describe BetterAppGen::Generators::Docker, :generator do
  let(:generator) { described_class.new(config) }

  describe "#generate!" do
    before { generator.generate! }

    describe "directories" do
      it "creates .docker directory" do
        expect(File.directory?(file_path(".docker"))).to be true
      end

      it "creates script directory" do
        expect(File.directory?(file_path("script"))).to be true
      end
    end

    describe "Dockerfile.dev" do
      it "creates .docker/Dockerfile.dev" do
        expect(file_exists?(".docker/Dockerfile.dev")).to be true
      end

      it "contains Docker instructions" do
        content = read_generated_file(".docker/Dockerfile.dev")
        expect(content).to include("FROM")
      end
    end

    describe "Dockerfile.prod" do
      it "creates .docker/Dockerfile.prod" do
        expect(file_exists?(".docker/Dockerfile.prod")).to be true
      end

      it "contains Docker instructions" do
        content = read_generated_file(".docker/Dockerfile.prod")
        expect(content).to include("FROM")
      end
    end

    describe "compose files" do
      it "creates compose.yml" do
        expect(file_exists?("compose.yml")).to be true
      end

      it "creates compose.runner.yml" do
        expect(file_exists?("compose.runner.yml")).to be true
      end

      it "compose.yml contains services" do
        content = read_generated_file("compose.yml")
        expect(content).to include("services:")
      end
    end

    describe "docker env" do
      it "creates .env.docker" do
        expect(file_exists?(".env.docker")).to be true
      end
    end

    describe "docker entrypoint" do
      it "creates bin/docker-entrypoint" do
        expect(file_exists?("bin/docker-entrypoint")).to be true
      end

      it "is executable" do
        expect(File.executable?(file_path("bin/docker-entrypoint"))).to be true
      end
    end

    describe "docker entrypoint prod" do
      it "creates bin/docker-entrypoint.prod" do
        expect(file_exists?("bin/docker-entrypoint.prod")).to be true
      end

      it "is executable" do
        expect(File.executable?(file_path("bin/docker-entrypoint.prod"))).to be true
      end
    end

    describe "deploy docs" do
      it "creates .docker/DEPLOY.md" do
        expect(file_exists?(".docker/DEPLOY.md")).to be true
      end
    end

    describe "management scripts" do
      let(:expected_scripts) do
        %w[dc-up dc-down dc-shell dc-rails dc-logs dc-logs-tail dc-attach dc-build dc-restart]
      end

      it "creates scripts that have templates" do
        expected_scripts.each do |script|
          template_path = BetterAppGen.templates_path.join("script/#{script}.erb")
          next unless template_path.exist?

          expect(file_exists?("script/#{script}")).to be true
        end
      end

      it "makes scripts executable" do
        expected_scripts.each do |script|
          script_path = file_path("script/#{script}")
          next unless File.exist?(script_path)

          expect(File.executable?(script_path)).to be true
        end
      end
    end

    describe "robots.txt" do
      it "creates public/robots.txt" do
        expect(file_exists?("public/robots.txt")).to be true
      end
    end
  end
end
