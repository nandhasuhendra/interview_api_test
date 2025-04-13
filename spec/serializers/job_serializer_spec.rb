require 'rails_helper'

RSpec.describe JobSerializer, type: :serializer do
  let(:user) { create(:user) }  # Assuming you have a user factory
  let(:job) { create(:job, user: user) }  # Assuming you have a job factory

  describe 'attributes' do
    subject { ActiveModelSerializers::Adapter.create(JobSerializer.new(job)) }

    it 'includes the id' do
      expect(subject.serializable_hash[:id]).to eq(job.id)
    end

    it 'includes the title' do
      expect(subject.serializable_hash[:title]).to eq(job.title)
    end

    it 'includes the description' do
      expect(subject.serializable_hash[:description]).to eq(job.description)
    end

    it 'includes the status' do
      expect(subject.serializable_hash[:status]).to eq(job.status)
    end

    it 'includes the user_id' do
      expect(subject.serializable_hash[:user_id]).to eq(job.user_id)
    end
  end

  describe 'associations' do
    subject { ActiveModelSerializers::Adapter.create(JobSerializer.new(job)) }

    it 'includes the associated user' do
      expect(subject.serializable_hash[:user]).to_not be_blank
    end
  end
end

