RSpec.shared_examples_for Archivable do
  let(:factory_name) { described_class.name.underscore }

  describe 'scope unarchived' do
    it 'returns unarchived records' do
      archived_record = FactoryGirl.create factory_name, archived_at: Time.now
      unarchived_record = FactoryGirl.create factory_name, archived_at: nil
      expect(described_class.unarchived).to eq [unarchived_record]
    end
  end

  describe 'scope archived' do
    it 'returns archived records' do
      archived_record = FactoryGirl.create factory_name, archived_at: Time.now
      unarchived_record = FactoryGirl.create factory_name, archived_at: nil
      expect(described_class.archived).to eq [archived_record]
    end
  end

  describe '#archive!', timecop: :freeze do
    it 'sets the time the record was archived' do
      record = FactoryGirl.create factory_name
      expect {
        record.archive!
      }.to change { record.archived_at }.from(nil).to Time.now
    end
  end

  describe '#unarchive!', timecop: :freeze do
    it 'clears the time the record was archived' do
      record = FactoryGirl.create factory_name, archived_at: Time.now
      expect {
        record.unarchive!
      }.to change { record.archived_at }.from(Time.now).to nil
    end
  end

  describe '#toggle_archive!', timecop: :freeze do
    it 'toggles the time the record was archived from nil to the current time and vice-versa' do
      record = FactoryGirl.create factory_name
      expect {
        record.toggle_archive!
      }.to change { record.archived_at }.from(nil).to Time.now
      expect {
        record.toggle_archive!
      }.to change { record.archived_at }.from(Time.now).to nil
    end
  end

  describe '#archived?' do
    it 'returns whether the record is archived' do
      record = FactoryGirl.create factory_name
      expect {
        record.archive!
      }.to change { record.archived? }.from(false).to true
    end
  end

  describe '#unarchived?' do
    it 'returns whether the record is archived' do
      record = FactoryGirl.create factory_name
      expect {
        record.archive!
      }.to change { record.unarchived? }.from(true).to false
    end
  end
end
