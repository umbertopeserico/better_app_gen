# frozen_string_literal: true

module BetterAppgen
  module Generators
    # Configures the Gemfile with required gems
    class Gemfile < Base
      SOLID_GEMS = [
        'gem "solid_cache"',
        'gem "solid_queue"',
        'gem "solid_cable"'
      ].freeze

      BASE_GEMS = [
        'gem "rails-i18n"'
      ].freeze

      def generate!
        gems_to_add = SOLID_GEMS + BASE_GEMS
        gems_to_add << 'gem "simple_form"' if with_simple_form

        merge_gemfile(gems_to_add)
      end
    end
  end
end
