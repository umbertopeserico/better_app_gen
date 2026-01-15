# frozen_string_literal: true

RSpec.describe BetterAppGen::Generators::Database, :generator do
  let(:generator) { described_class.new(config) }

  describe "#generate!" do
    before { generator.generate! }

    describe "database.yml" do
      it "creates config/database.yml" do
        expect(file_exists?("config/database.yml")).to be true
      end

      it "contains database configuration" do
        content = read_generated_file("config/database.yml")
        expect(content).to include("default:")
      end

      it "configures primary database" do
        content = read_generated_file("config/database.yml")
        expect(content).to include("primary")
      end
    end

    describe "migrations" do
      it "creates UUID extension migration in db/migrate" do
        files = Dir.glob(file_path("db/migrate/*_enable_uuid_extension.rb"))
        expect(files.length).to eq(1)
      end

      it "creates shared schema migration in db/migrate" do
        files = Dir.glob(file_path("db/migrate/*_create_shared_schema.rb"))
        expect(files.length).to eq(1)
      end

      it "creates solid_cache migration in db/cache_migrate" do
        files = Dir.glob(file_path("db/cache_migrate/*_create_solid_cache_schema.rb"))
        expect(files.length).to eq(1)
      end

      it "creates solid_queue migration in db/queue_migrate" do
        files = Dir.glob(file_path("db/queue_migrate/*_create_solid_queue_schema.rb"))
        expect(files.length).to eq(1)
      end

      it "creates solid_cable migration in db/cable_migrate" do
        files = Dir.glob(file_path("db/cable_migrate/*_create_solid_cable_schema.rb"))
        expect(files.length).to eq(1)
      end

      it "migrations have sequential timestamps" do
        uuid_files = Dir.glob(file_path("db/migrate/*_enable_uuid_extension.rb"))
        shared_files = Dir.glob(file_path("db/migrate/*_create_shared_schema.rb"))

        uuid_timestamp = uuid_files.first.match(/(\d{14})/)[1].to_i
        shared_timestamp = shared_files.first.match(/(\d{14})/)[1].to_i

        expect(shared_timestamp).to be >= uuid_timestamp
      end
    end

    describe "rake task" do
      it "creates lib/tasks/db.rake" do
        expect(file_exists?("lib/tasks/db.rake")).to be true
      end

      it "contains rake task definitions" do
        content = read_generated_file("lib/tasks/db.rake")
        expect(content).to include("namespace")
      end
    end

    describe "schema settings initializer" do
      it "creates active_record_schema_settings.rb" do
        expect(file_exists?("config/initializers/active_record_schema_settings.rb")).to be true
      end

      it "contains ActiveRecord configuration" do
        content = read_generated_file("config/initializers/active_record_schema_settings.rb")
        expect(content).to include("ActiveRecord")
      end
    end
  end
end
