# frozen_string_literal: true

module BetterAppGen
  module Generators
    # Configures i18n with the selected locale
    class Locale < Base
      def generate!
        create_locale_file if locale != "en"
      end

      private

      def create_locale_file
        template_name = "config/locales/#{locale}.yml.erb"

        # Only create if template exists for this locale
        template_path = BetterAppGen.templates_path.join(template_name)
        return unless template_path.exist?

        create_file_from_template("config/locales/#{locale}.yml", template_name)
      end
    end
  end
end
