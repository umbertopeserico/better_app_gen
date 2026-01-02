# frozen_string_literal: true

module BetterAppGen
  module Generators
    # Configures Solid Stack (Cache, Queue, Cable) in application.rb
    class SolidStack < Base
      def generate!
        create_application_rb
      end

      private

      def create_application_rb
        create_file_from_template("config/application.rb", "config/application.rb.erb")
      end
    end
  end
end
