# frozen_string_literal: true

module BetterAppgen
  module Generators
    # Configures SimpleForm with Tailwind CSS styling
    class SimpleForm < Base
      def generate!
        create_initializer
        create_locale_file if locale != "en"
      end

      private

      def create_initializer
        create_file_from_template(
          "config/initializers/simple_form.rb",
          "config/initializers/simple_form.rb.erb"
        )
      end

      def create_locale_file
        template_name = "config/locales/simple_form.#{locale}.yml.erb"
        template_path = BetterAppgen.templates_path.join(template_name)
        return unless template_path.exist?

        create_file_from_template(
          "config/locales/simple_form.#{locale}.yml",
          template_name
        )
      end
    end
  end
end
