module SagaciousSuccotash
  module Helpers
    def app_name_capitalized_spaced
      app_name.split('_').map(&:capitalize).join(' ')
    end
  end
end
