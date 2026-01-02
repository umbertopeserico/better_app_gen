# frozen_string_literal: true

require_relative "better_appgen/version"
require_relative "better_appgen/errors"
require_relative "better_appgen/configuration"
require_relative "better_appgen/dependency_checker"
require_relative "better_appgen/generators/base"
require_relative "better_appgen/app_generator"
require_relative "better_appgen/cli"

module BetterAppgen
  class << self
    # Returns the root path of the gem
    def root
      @root ||= Pathname.new(File.expand_path("..", __dir__))
    end

    # Returns the path to the templates directory
    def templates_path
      @templates_path ||= root.join("lib", "better_appgen", "templates")
    end
  end
end
