require 'rails_helper'

RSpec.describe UserSerializer, type: :serializer do
  let(:user) { create(:user) }  # Assuming you have a user factory
  let(:job) { create(:job, user: user) }  # Assuming you have a job factory
  
  before do
    user.jobs << job  # Associate the job with the user
  end

  describe 'attributes' do
    subject { ActiveModelSerializers::Adapter.create(UserSerializer.new(user)) }

    it 'includes the id' do
      expect(subject.serializable_hash[:id]).to eq(user.id)
    end

    it 'includes the name' do
      expect(subject.serializable_hash[:name]).to eq(user.name)
    end

    it 'includes the email' do
      expect(subject.serializable_hash[:email]).to eq(user.email)
    end

    it 'includes the phone' do
      expect(subject.serializable_hash[:phone]).to eq(user.phone)
    end
  end

  describe 'associations' do
    subject { ActiveModelSerializers::Adapter.create(UserSerializer.new(user)) }

    it 'includes the associated jobs' do
      expect(subject.serializable_hash[:jobs].size).to eq(user.jobs.size)
    end
  end
end
