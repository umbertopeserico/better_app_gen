# frozen_string_literal: true

RSpec.describe BetterAppGen do
  describe BetterAppGen::Error do
    it "is a StandardError" do
      expect(described_class.new).to be_a(StandardError)
    end

    it "accepts a message" do
      error = described_class.new("custom message")
      expect(error.message).to eq("custom message")
    end
  end

  describe BetterAppGen::DependencyError do
    it "is a BetterAppGen::Error" do
      error = described_class.new([ "ruby" ])
      expect(error).to be_a(BetterAppGen::Error)
    end

    it "stores missing_dependencies" do
      error = described_class.new(%w[ruby node])
      expect(error.missing_dependencies).to eq(%w[ruby node])
    end

    it "formats the message with missing dependencies" do
      error = described_class.new(%w[ruby node])
      expect(error.message).to eq("Missing required dependencies: ruby, node")
    end

    it "handles single dependency" do
      error = described_class.new([ "psql" ])
      expect(error.message).to eq("Missing required dependencies: psql")
    end
  end

  describe BetterAppGen::InvalidAppNameError do
    it "is a BetterAppGen::Error" do
      error = described_class.new("123bad")
      expect(error).to be_a(BetterAppGen::Error)
    end

    it "includes the invalid app name in the message" do
      error = described_class.new("123bad")
      expect(error.message).to include("123bad")
    end

    it "explains valid app name rules" do
      error = described_class.new("bad name")
      expect(error.message).to include("must start with a letter")
      expect(error.message).to include("letters, numbers, hyphens, and underscores")
    end
  end

  describe BetterAppGen::DirectoryExistsError do
    it "is a BetterAppGen::Error" do
      error = described_class.new("/path/to/app")
      expect(error).to be_a(BetterAppGen::Error)
    end

    it "includes the path in the message" do
      error = described_class.new("/home/user/my_app")
      expect(error.message).to include("/home/user/my_app")
    end

    it "suggests removing or renaming" do
      error = described_class.new("/some/path")
      expect(error.message).to include("already exists")
      expect(error.message).to include("remove the existing directory")
    end
  end

  describe BetterAppGen::TemplateNotFoundError do
    it "is a BetterAppGen::Error" do
      error = described_class.new("missing.erb")
      expect(error).to be_a(BetterAppGen::Error)
    end

    it "includes the template path in the message" do
      error = described_class.new("/templates/config/database.yml.erb")
      expect(error.message).to include("/templates/config/database.yml.erb")
    end

    it "indicates the file was not found" do
      error = described_class.new("test.erb")
      expect(error.message).to include("not found")
    end
  end

  describe BetterAppGen::CommandFailedError do
    it "is a BetterAppGen::Error" do
      error = described_class.new("rails new", 1)
      expect(error).to be_a(BetterAppGen::Error)
    end

    it "stores the command" do
      error = described_class.new("bundle install", 127)
      expect(error.command).to eq("bundle install")
    end

    it "stores the exit_code" do
      error = described_class.new("yarn install", 42)
      expect(error.exit_code).to eq(42)
    end

    it "formats the message with command and exit code" do
      error = described_class.new("npm test", 1)
      expect(error.message).to eq("Command 'npm test' failed with exit code 1")
    end
  end

  describe BetterAppGen::RailsGenerationError do
    it "is a BetterAppGen::Error" do
      error = described_class.new
      expect(error).to be_a(BetterAppGen::Error)
    end

    it "has a default message" do
      error = described_class.new
      expect(error.message).to eq("Failed to generate Rails application")
    end

    it "accepts a custom message" do
      error = described_class.new("Custom error occurred")
      expect(error.message).to eq("Custom error occurred")
    end
  end
end
