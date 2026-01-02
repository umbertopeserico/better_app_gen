# frozen_string_literal: true

require_relative "better_app_gen/version"
require_relative "better_app_gen/errors"
require_relative "better_app_gen/configuration"
require_relative "better_app_gen/dependency_checker"
require_relative "better_app_gen/generators/base"
require_relative "better_app_gen/app_generator"
require_relative "better_app_gen/cli"

module BetterAppGen
  class << self
    # Returns the root path of the gem
    def root
      @root ||= Pathname.new(File.expand_path("..", __dir__))
    end

    # Returns the path to the templates directory
    def templates_path
      @templates_path ||= root.join("lib", "better_app_gen", "templates")
    end
  end
end
