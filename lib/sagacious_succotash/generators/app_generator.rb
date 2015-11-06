require 'rails/generators'
require 'rails/generators/rails/app/app_generator'

module SagaciousSuccotash
  class AppGenerator < Rails::Generators::AppGenerator

    def finish_template
      invoke :sagacious_succotash_customization
      super
    end

    def sagacious_succotash_customization
      invoke :outro
    end

    def outro
      say 'Mmmm, succotash.'
    end

    protected

    def get_builder_class
      SagaciousSuccotash::AppBuilder
    end
  end
end
