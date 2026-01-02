# frozen_string_literal: true

module BetterAppGen
  module Generators
    # Creates HomeController with index action and root route
    class HomeController < Base
      def generate!
        create_directory("app/views/home")
        create_controller
        create_helper
        create_view
        create_routes
      end

      private

      def create_controller
        create_file_from_template("app/controllers/home_controller.rb", "app/controllers/home_controller.rb.erb")
      end

      def create_helper
        create_file_from_template("app/helpers/home_helper.rb", "app/helpers/home_helper.rb.erb")
      end

      def create_view
        create_file_from_template("app/views/home/index.html.erb", "app/views/home/index.html.erb.erb")
      end

      def create_routes
        create_file_from_template("config/routes.rb", "config/routes.rb.erb")
      end
    end
  end
end
