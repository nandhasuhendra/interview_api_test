require 'rails_helper'

RSpec.describe Job, type: :model do
  # FactoryBot setup for the associated user and job
  let(:user) { create(:user) }
  let(:job) { build(:job, user: user) }

  describe 'validations' do
    it 'is valid with valid attributes' do
      expect(job).to be_valid
    end

    it 'is not valid without a title' do
      job.title = nil
      expect(job).not_to be_valid
      expect(job.errors[:title]).to include("can't be blank")
    end

    it 'is not valid without a description' do
      job.description = nil
      expect(job).not_to be_valid
      expect(job.errors[:description]).to include("can't be blank")
    end

    it 'is not valid without a status' do
      job.status = nil
      expect(job).not_to be_valid
      expect(job.errors[:status]).to include("can't be blank")
    end

    it 'is not valid with an invalid status' do
      job.status = 'invalid_status'
      expect(job).not_to be_valid
      expect(job.errors[:status]).to include("is not included in the list")
    end

    it 'is valid with a status of "pending", "in_progress", or "completed"' do
      job.status = 'pending'
      expect(job).to be_valid

      job.status = 'in_progress'
      expect(job).to be_valid

      job.status = 'completed'
      expect(job).to be_valid
    end
  end

  describe 'associations' do
    it 'belongs to a user' do
      assoc = Job.reflect_on_association(:user)
      expect(assoc.macro).to eq(:belongs_to)
    end
  end

  describe 'callbacks' do
    it 'refreshes the cache after commit' do
      # Expect Rails.cache.delete to be called when a job is saved
      expect(Rails.cache).to receive(:delete).with("user_*")
      expect(Rails.cache).to receive(:delete).with("jobs_user_*")
      expect(Rails.cache).to receive(:delete).with("jobs_all")

      job.save
    end
  end
end

