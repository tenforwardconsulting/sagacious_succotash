require 'rails_helper'

RSpec.shared_examples_for 'ModelPolicy' do
  let(:factory_name) { described_class.name.underscore.gsub('_policy', '') }
  let(:record) { FactoryGirl.create factory_name }

  describe '#show?' do
    it 'returns false if it does not exist' do
      admin = FactoryGirl.create :admin
      policy = described_class.new(admin, record)
      expect {
        record.destroy
      }.to change { policy.show? }.from(true).to false
    end
  end
end
