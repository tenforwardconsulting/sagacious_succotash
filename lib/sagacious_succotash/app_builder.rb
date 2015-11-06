module SagaciousSuccotash
  class AppBuilder < Rails::AppBuilder
    include SagaciousSuccotash::Actions

  end
end
