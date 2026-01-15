# frozen_string_literal: true

RSpec.describe BetterAppGen::Generators::Base, :generator do
  # Create a concrete subclass to test protected methods
  let(:generator_class) do
    Class.new(described_class) do
      # Expose protected methods for testing
      public :app_name, :app_name_snake, :app_name_pascal, :app_name_dash
      public :rails_port, :vite_port, :locale, :timezone
      public :with_simple_form, :skip_docker, :app_path
      public :templates_path, :render_template
      public :create_file, :create_file_from_template, :read_file, :update_file
      public :file_exists?, :append_to_file, :insert_before, :insert_after
      public :gsub_file, :merge_gemfile, :merge_package_json
      public :create_directory, :copy_file, :chmod_executable, :remove_file
      public :migration_timestamp, :run_command, :run_command!
    end
  end

  let(:generator) { generator_class.new(config) }

  describe "#initialize" do
    it "stores the config" do
      expect(generator.config).to eq(config)
    end
  end

  describe "#generate!" do
    it "raises NotImplementedError" do
      expect { generator.generate! }.to raise_error(NotImplementedError, /Subclasses must implement/)
    end
  end

  describe "config delegation" do
    it "delegates app_name" do
      expect(generator.app_name).to eq("test_app")
    end

    it "delegates app_name_snake" do
      expect(generator.app_name_snake).to eq("test_app")
    end

    it "delegates app_name_pascal" do
      expect(generator.app_name_pascal).to eq("TestApp")
    end

    it "delegates app_name_dash" do
      expect(generator.app_name_dash).to eq("test-app")
    end

    it "delegates rails_port" do
      expect(generator.rails_port).to eq(3000)
    end

    it "delegates vite_port" do
      expect(generator.vite_port).to eq(5173)
    end

    it "delegates locale" do
      expect(generator.locale).to eq("en")
    end

    it "delegates timezone" do
      expect(generator.timezone).to be_a(String)
    end

    it "delegates with_simple_form" do
      expect([true, false]).to include(generator.with_simple_form)
    end

    it "delegates skip_docker" do
      expect([true, false]).to include(generator.skip_docker)
    end

    it "delegates app_path" do
      expect(generator.app_path).to eq(app_path)
    end
  end

  describe "#templates_path" do
    it "returns the templates directory" do
      expect(generator.templates_path).to eq(BetterAppGen.templates_path)
    end

    it "returns a Pathname" do
      expect(generator.templates_path).to be_a(Pathname)
    end
  end

  describe "#create_file" do
    it "creates a file with content" do
      generator.create_file("test.txt", "Hello World")
      expect(File.read(file_path("test.txt"))).to eq("Hello World")
    end

    it "creates parent directories" do
      generator.create_file("nested/deep/file.txt", "content")
      expect(File.read(file_path("nested/deep/file.txt"))).to eq("content")
    end
  end

  describe "#read_file" do
    before do
      create_test_file("existing.txt", "existing content")
    end

    it "reads file content" do
      expect(generator.read_file("existing.txt")).to eq("existing content")
    end
  end

  describe "#update_file" do
    before do
      create_test_file("to_update.txt", "original")
    end

    it "replaces file content" do
      generator.update_file("to_update.txt", "new content")
      expect(File.read(file_path("to_update.txt"))).to eq("new content")
    end
  end

  describe "#file_exists?" do
    it "returns true for existing file" do
      create_test_file("exists.txt", "content")
      expect(generator.file_exists?("exists.txt")).to be true
    end

    it "returns false for non-existing file" do
      expect(generator.file_exists?("does_not_exist.txt")).to be false
    end
  end

  describe "#append_to_file" do
    before do
      create_test_file("appendable.txt", "line1\n")
    end

    it "appends content to file" do
      generator.append_to_file("appendable.txt", "line2\n")
      expect(File.read(file_path("appendable.txt"))).to eq("line1\nline2\n")
    end

    it "does not duplicate content already present" do
      generator.append_to_file("appendable.txt", "line1\n")
      expect(File.read(file_path("appendable.txt"))).to eq("line1\n")
    end
  end

  describe "#insert_before" do
    before do
      create_test_file("insert.txt", "line1\nmarker\nline3\n")
    end

    it "inserts content before pattern" do
      generator.insert_before("insert.txt", /marker/, "inserted\n")
      expect(File.read(file_path("insert.txt"))).to eq("line1\ninserted\nmarker\nline3\n")
    end
  end

  describe "#insert_after" do
    before do
      create_test_file("insert.txt", "line1\nmarker\nline3\n")
    end

    it "inserts content after pattern" do
      generator.insert_after("insert.txt", /marker/, "\ninserted")
      expect(File.read(file_path("insert.txt"))).to eq("line1\nmarker\ninserted\nline3\n")
    end
  end

  describe "#gsub_file" do
    before do
      create_test_file("replace.txt", "old_value is here")
    end

    it "replaces matching content" do
      generator.gsub_file("replace.txt", /old_value/, "new_value")
      expect(File.read(file_path("replace.txt"))).to eq("new_value is here")
    end

    it "handles regex patterns" do
      generator.gsub_file("replace.txt", /old_\w+/, "replaced")
      expect(File.read(file_path("replace.txt"))).to eq("replaced is here")
    end
  end

  describe "#create_directory" do
    it "creates a directory" do
      generator.create_directory("new_dir")
      expect(File.directory?(file_path("new_dir"))).to be true
    end

    it "creates nested directories" do
      generator.create_directory("deep/nested/dir")
      expect(File.directory?(file_path("deep/nested/dir"))).to be true
    end
  end

  describe "#copy_file" do
    before do
      create_test_file("source.txt", "source content")
    end

    it "copies file to destination" do
      generator.copy_file("source.txt", "dest.txt")
      expect(File.read(file_path("dest.txt"))).to eq("source content")
    end

    it "creates destination directory" do
      generator.copy_file("source.txt", "nested/dest.txt")
      expect(File.read(file_path("nested/dest.txt"))).to eq("source content")
    end
  end

  describe "#chmod_executable" do
    before do
      create_test_file("script.sh", "#!/bin/bash\necho hello")
    end

    it "makes file executable" do
      generator.chmod_executable("script.sh")
      expect(File.executable?(file_path("script.sh"))).to be true
    end
  end

  describe "#remove_file" do
    it "removes a file" do
      create_test_file("to_delete.txt", "content")
      generator.remove_file("to_delete.txt")
      expect(File.exist?(file_path("to_delete.txt"))).to be false
    end

    it "removes a directory recursively" do
      FileUtils.mkdir_p(file_path("dir_to_delete/nested"))
      create_test_file("dir_to_delete/nested/file.txt", "content")
      generator.remove_file("dir_to_delete")
      expect(File.exist?(file_path("dir_to_delete"))).to be false
    end

    it "does not raise for non-existing path" do
      expect { generator.remove_file("non_existing") }.not_to raise_error
    end
  end

  describe "#migration_timestamp" do
    it "returns a timestamp string" do
      timestamp = generator.migration_timestamp
      expect(timestamp).to match(/^\d{14}$/)
    end

    it "accepts offset in seconds" do
      timestamp1 = generator.migration_timestamp(0)
      timestamp2 = generator.migration_timestamp(1)
      expect(timestamp2.to_i).to be >= timestamp1.to_i
    end
  end

  describe "#merge_gemfile" do
    before do
      create_test_file("Gemfile", <<~GEMFILE)
        source "https://rubygems.org"
        gem "rails"

        group :development do
          gem "debug"
        end
      GEMFILE
    end

    it "adds new gems before development group" do
      generator.merge_gemfile(['gem "solid_cache"'])
      content = File.read(file_path("Gemfile"))
      expect(content).to include('gem "solid_cache"')
      expect(content.index('gem "solid_cache"')).to be < content.index("group :development")
    end

    it "does not duplicate existing gems" do
      generator.merge_gemfile(['gem "rails"'])
      content = File.read(file_path("Gemfile"))
      expect(content.scan('gem "rails"').count).to eq(1)
    end

    it "adds multiple gems" do
      generator.merge_gemfile(['gem "solid_cache"', 'gem "solid_queue"'])
      content = File.read(file_path("Gemfile"))
      expect(content).to include('gem "solid_cache"')
      expect(content).to include('gem "solid_queue"')
    end
  end

  describe "#merge_gemfile without development group" do
    before do
      create_test_file("Gemfile", <<~GEMFILE)
        source "https://rubygems.org"
        gem "rails"
      GEMFILE
    end

    it "appends gems at end" do
      generator.merge_gemfile(['gem "new_gem"'])
      content = File.read(file_path("Gemfile"))
      expect(content).to include('gem "new_gem"')
    end
  end

  describe "#merge_package_json" do
    context "with existing package.json" do
      before do
        create_test_file("package.json", JSON.generate({
                                                         "name" => "existing",
                                                         "dependencies" => { "react" => "^18.0.0" },
                                                         "scripts" => { "start" => "node index.js" }
                                                       }))
      end

      it "merges dependencies" do
        generator.merge_package_json(dependencies: { "vue" => "^3.0.0" })
        data = JSON.parse(File.read(file_path("package.json")))
        expect(data["dependencies"]).to include("react" => "^18.0.0", "vue" => "^3.0.0")
      end

      it "merges dev_dependencies" do
        generator.merge_package_json(dev_dependencies: { "jest" => "^29.0.0" })
        data = JSON.parse(File.read(file_path("package.json")))
        expect(data["devDependencies"]).to include("jest" => "^29.0.0")
      end

      it "merges scripts" do
        generator.merge_package_json(scripts: { "test" => "jest" })
        data = JSON.parse(File.read(file_path("package.json")))
        expect(data["scripts"]).to include("start" => "node index.js", "test" => "jest")
      end

      it "merges extra fields" do
        generator.merge_package_json(extra: { "type" => "module" })
        data = JSON.parse(File.read(file_path("package.json")))
        expect(data["type"]).to eq("module")
      end
    end

    context "without existing package.json" do
      it "creates new package.json with defaults" do
        generator.merge_package_json(dependencies: { "lodash" => "^4.0.0" })
        data = JSON.parse(File.read(file_path("package.json")))
        expect(data["name"]).to eq("test-app")
        expect(data["private"]).to be true
        expect(data["dependencies"]).to include("lodash" => "^4.0.0")
      end
    end
  end

  describe "#run_command" do
    it "runs command in app directory" do
      result = generator.run_command("pwd", capture: true)
      # Use realpath to handle /var -> /private/var symlink on macOS
      expect(File.realpath(result.strip)).to eq(File.realpath(app_path))
    end

    it "captures output when capture: true" do
      result = generator.run_command("echo hello", capture: true)
      expect(result.strip).to eq("hello")
    end

    it "returns success status when capture: false" do
      result = generator.run_command("true")
      expect(result).to be true
    end
  end

  describe "#run_command!" do
    it "runs successful command without error" do
      expect { generator.run_command!("true") }.not_to raise_error
    end

    it "raises CommandFailedError on failure" do
      expect { generator.run_command!("false") }.to raise_error(BetterAppGen::CommandFailedError)
    end

    it "includes exit code in error" do
      expect { generator.run_command!("exit 42") }.to raise_error do |error|
        expect(error.exit_code).to eq(42)
      end
    end
  end

  describe "#render_template" do
    it "raises TemplateNotFoundError for missing template" do
      expect { generator.render_template("nonexistent.erb") }
        .to raise_error(BetterAppGen::TemplateNotFoundError)
    end

    # Test with an actual template that exists
    it "renders existing template with ERB bindings" do
      # Check if any template exists
      templates_dir = BetterAppGen.templates_path
      existing_template = Dir.glob(templates_dir.join("**/*.erb")).first

      if existing_template
        relative_template = Pathname.new(existing_template).relative_path_from(templates_dir).to_s
        expect { generator.render_template(relative_template) }.not_to raise_error
      else
        skip "No templates found for testing"
      end
    end
  end
end
