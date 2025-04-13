require 'rails_helper'

RSpec.describe User, type: :model do
  # FactoryBot setup for user and associated jobs
  let(:user) { build(:user) }

  describe 'validations' do
    it 'is valid with valid attributes' do
      expect(user).to be_valid
    end

    it 'is not valid without a name' do
      user.name = nil
      expect(user).not_to be_valid
      expect(user.errors[:name]).to include("can't be blank")
    end

    it 'is not valid without an email' do
      user.email = nil
      expect(user).not_to be_valid
      expect(user.errors[:email]).to include("can't be blank")
    end

    it 'is not valid with a non-unique email' do
      create(:user, email: 'test@example.com')  # Creating a user with this email
      user.email = 'test@example.com'
      expect(user).not_to be_valid
      expect(user.errors[:email]).to include("has already been taken")
    end

    it 'is not valid with an invalid email format' do
      user.email = 'invalid-email'
      expect(user).not_to be_valid
      expect(user.errors[:email]).to include("is invalid")
    end

    it 'is not valid without a phone' do
      user.phone = nil
      expect(user).not_to be_valid
      expect(user.errors[:phone]).to include("can't be blank")
    end
  end

  describe 'associations' do
    it 'has many jobs' do
      assoc = User.reflect_on_association(:jobs)
      expect(assoc.macro).to eq(:has_many)
    end

    it 'destroys jobs when user is destroyed' do
      user.save
      job = create(:job, user: user)
      expect { user.destroy }.to change { Job.count }.by(-1)
    end
  end

  describe 'callbacks' do
    it 'refreshes the cache after commit' do
      # Expect Rails.cache.delete to be called when a user is saved
      expect(Rails.cache).to receive(:delete).with("user_*")

      user.save
    end
  end
end

