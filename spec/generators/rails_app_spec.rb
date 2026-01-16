# frozen_string_literal: true

RSpec.describe BetterAppGen::Generators::RailsApp, :generator do
  let(:generator) { described_class.new(config) }

  describe "SKIP_FLAGS" do
    it "includes --skip-git" do
      expect(described_class::SKIP_FLAGS).to include("--skip-git")
    end

    it "includes --skip-docker" do
      expect(described_class::SKIP_FLAGS).to include("--skip-docker")
    end

    it "includes --skip-action-mailbox" do
      expect(described_class::SKIP_FLAGS).to include("--skip-action-mailbox")
    end

    it "includes --skip-action-text" do
      expect(described_class::SKIP_FLAGS).to include("--skip-action-text")
    end

    it "includes --skip-active-storage" do
      expect(described_class::SKIP_FLAGS).to include("--skip-active-storage")
    end

    it "includes --skip-test" do
      expect(described_class::SKIP_FLAGS).to include("--skip-test")
    end

    it "includes --skip-javascript" do
      expect(described_class::SKIP_FLAGS).to include("--skip-javascript")
    end

    it "includes --skip-asset-pipeline" do
      expect(described_class::SKIP_FLAGS).to include("--skip-asset-pipeline")
    end

    it "includes --database=postgresql" do
      expect(described_class::SKIP_FLAGS).to include("--database=postgresql")
    end
  end

  describe "#generate!" do
    before do
      # Mock the rails new command to avoid actually running it
      allow(generator).to receive(:system).and_return(true)

      # Create fake db directory with schema files to test cleanup
      db_path = file_path("db")
      FileUtils.mkdir_p(db_path)
      File.write(File.join(db_path, "schema.rb"), "# schema")
      File.write(File.join(db_path, "primary_schema.rb"), "# primary schema")
    end

    context "when rails new succeeds" do
      it "creates migration directories" do
        generator.generate!

        expect(File.directory?(file_path("db/migrate"))).to be true
        expect(File.directory?(file_path("db/cache_migrate"))).to be true
        expect(File.directory?(file_path("db/queue_migrate"))).to be true
        expect(File.directory?(file_path("db/cable_migrate"))).to be true
      end

      it "removes schema.rb files" do
        generator.generate!

        expect(File.exist?(file_path("db/schema.rb"))).to be false
        expect(File.exist?(file_path("db/primary_schema.rb"))).to be false
      end

      it "calls rails new with correct flags" do
        expected_command = "rails new test_app #{described_class::SKIP_FLAGS.join(" ")}"
        allow(generator).to receive(:system).with(expected_command).and_return(true)

        generator.generate!
        expect(generator).to have_received(:system).with(expected_command)
      end
    end

    context "when rails new fails" do
      before do
        allow(generator).to receive(:system).and_return(false)
      end

      it "raises RailsGenerationError" do
        expect { generator.generate! }.to raise_error(BetterAppGen::RailsGenerationError)
      end
    end
  end

  describe "cleanup_schema_files" do
    before do
      # Create schema files to cleanup
      db_path = file_path("db")
      FileUtils.mkdir_p(db_path)
      File.write(File.join(db_path, "schema.rb"), "# schema")
      File.write(File.join(db_path, "cache_schema.rb"), "# cache schema")

      # Stub system call to avoid running rails new
      allow(generator).to receive(:system).and_return(true)
    end

    it "removes all *schema.rb files" do
      generator.generate!

      expect(File.exist?(file_path("db/schema.rb"))).to be false
      expect(File.exist?(file_path("db/cache_schema.rb"))).to be false
    end
  end

  describe "setup_migration_directories" do
    before do
      allow(generator).to receive(:system).and_return(true)
      FileUtils.mkdir_p(file_path("db"))
    end

    it "creates all four migration directories" do
      generator.generate!

      %w[migrate cache_migrate queue_migrate cable_migrate].each do |dir|
        expect(File.directory?(file_path("db/#{dir}"))).to be true
      end
    end
  end
end
