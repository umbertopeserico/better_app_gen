# frozen_string_literal: true

module BetterAppgen
  module Generators
    # Sets up database configuration and migrations
    class Database < Base
      def generate!
        create_database_yml
        create_migrations
        create_db_rake_task
        create_schema_settings_initializer
      end

      private

      def create_database_yml
        create_file_from_template("config/database.yml", "config/database.yml.erb")
      end

      def create_migrations
        # UUID extension migration
        create_file_from_template(
          "db/migrate/#{migration_timestamp(0)}_enable_uuid_extension.rb",
          "db/migrate/enable_uuid_extension.rb.erb"
        )

        # Shared schema migration
        create_file_from_template(
          "db/migrate/#{migration_timestamp(1)}_create_shared_schema.rb",
          "db/migrate/create_shared_schema.rb.erb"
        )

        # Solid Cache migration
        create_file_from_template(
          "db/cache_migrate/#{migration_timestamp(2)}_create_solid_cache_schema.rb",
          "db/cache_migrate/create_solid_cache_schema.rb.erb"
        )

        # Solid Queue migration
        create_file_from_template(
          "db/queue_migrate/#{migration_timestamp(3)}_create_solid_queue_schema.rb",
          "db/queue_migrate/create_solid_queue_schema.rb.erb"
        )

        # Solid Cable migration
        create_file_from_template(
          "db/cable_migrate/#{migration_timestamp(4)}_create_solid_cable_schema.rb",
          "db/cable_migrate/create_solid_cable_schema.rb.erb"
        )
      end

      def create_db_rake_task
        create_file_from_template("lib/tasks/db.rake", "lib/tasks/db.rake.erb")
      end

      def create_schema_settings_initializer
        create_file_from_template(
          "config/initializers/active_record_schema_settings.rb",
          "config/initializers/active_record_schema_settings.rb.erb"
        )
      end
    end
  end
end
