# frozen_string_literal: true

require "tty-spinner"
require "pastel"

module BetterAppgen
  # Main orchestrator for generating a complete Rails application
  class AppGenerator
    attr_reader :config, :pastel

    def initialize(config)
      @config = config
      @pastel = Pastel.new
    end

    def generate!
      run_generator("Creating Rails application", Generators::RailsApp)
      run_generator("Configuring Gemfile", Generators::Gemfile)
      run_generator("Setting up database configuration", Generators::Database)
      run_generator("Configuring Solid Stack", Generators::SolidStack)
      run_generator("Setting up Vite + Tailwind CSS", Generators::Vite)
      run_generator("Creating HomeController", Generators::HomeController)
      run_generator("Configuring locale", Generators::Locale)
      run_generator("Setting up Docker", Generators::Docker) unless config.skip_docker
      run_generator("Configuring SimpleForm", Generators::SimpleForm) if config.with_simple_form
      run_post_generation_tasks
    end

    private

    def run_generator(description, generator_class)
      spinner = TTY::Spinner.new("[:spinner] #{description}...", format: :dots)
      spinner.auto_spin

      begin
        generator = generator_class.new(config)
        generator.generate!
        spinner.success(pastel.green("done"))
      rescue StandardError => e
        spinner.error(pastel.red("failed"))
        raise e
      end
    end

    def run_post_generation_tasks
      spinner = TTY::Spinner.new("[:spinner] Installing dependencies...", format: :dots)
      spinner.auto_spin

      begin
        Dir.chdir(config.app_path) do
          # Run outside of bundler environment
          Bundler.with_unbundled_env do
            system("bundle install > /dev/null 2>&1")
            system("yarn install > /dev/null 2>&1")
          end
        end
        spinner.success(pastel.green("done"))
      rescue StandardError => e
        spinner.error(pastel.red("failed"))
        raise e
      end
    end
  end
end

# Require all generators
require_relative "generators/rails_app"
require_relative "generators/gemfile"
require_relative "generators/database"
require_relative "generators/solid_stack"
require_relative "generators/vite"
require_relative "generators/home_controller"
require_relative "generators/locale"
require_relative "generators/docker"
require_relative "generators/simple_form"
