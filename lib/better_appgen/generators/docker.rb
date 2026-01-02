# frozen_string_literal: true

module BetterAppgen
  module Generators
    # Sets up Docker development environment
    class Docker < Base
      def generate!
        create_directory(".docker")
        create_directory("script")

        create_dockerfile
        create_compose_files
        create_docker_env
        create_docker_entrypoint
        create_management_scripts
        create_robots_txt
      end

      private

      def create_dockerfile
        create_file_from_template(".docker/Dockerfile.dev", "docker/Dockerfile.dev.erb")
      end

      def create_compose_files
        create_file_from_template("compose.yml", "docker/compose.yml.erb")
        create_file_from_template("compose.runner.yml", "docker/compose.runner.yml.erb")
      end

      def create_docker_env
        create_file_from_template(".env.docker", "docker/env.docker.erb")
      end

      def create_docker_entrypoint
        create_file_from_template("bin/docker-entrypoint", "bin/docker-entrypoint.erb")
        chmod_executable("bin/docker-entrypoint")
      end

      def create_management_scripts
        scripts = %w[dc-up dc-down dc-shell dc-rails dc-logs dc-logs-tail dc-attach dc-build dc-restart]

        scripts.each do |script|
          template_name = "script/#{script}.erb"
          template_path = BetterAppgen.templates_path.join(template_name)
          next unless template_path.exist?

          create_file_from_template("script/#{script}", template_name)
          chmod_executable("script/#{script}")
        end
      end

      def create_robots_txt
        create_file_from_template("public/robots.txt", "public/robots.txt.erb")
      end
    end
  end
end
