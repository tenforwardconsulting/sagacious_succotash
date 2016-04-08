module SagaciousSuccotash
  module Helpers
    def app_name_capitalized_spaced
      app_name.camelize.gsub(/([A-Z])/, ' \1').strip
    end

    def app_name_capitalized_dasherized
      app_name.split('_').map(&:capitalize).join('-')
    end
  end
end
