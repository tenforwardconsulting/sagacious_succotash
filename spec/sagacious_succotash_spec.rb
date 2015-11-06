require 'spec_helper'

describe SagaciousSuccotash do
  it 'has a version number' do
    expect(SagaciousSuccotash::VERSION).not_to be nil
  end

  it 'has a ruby version' do
    expect(SagaciousSuccotash::RUBY_VERSION).not_to be nil
  end

  it 'has a rails version' do
    expect(SagaciousSuccotash::RAILS_VERSION).not_to be nil
  end
end
