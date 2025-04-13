require 'rails_helper'

RSpec.describe Api::V1::UsersController, type: :controller do
  let!(:user) { create(:user) }
  let!(:another_user) { create(:user) }

  describe 'GET #index' do
    it 'returns all users from the cache' do
      # Mocking Rails.cache.fetch to return a list of users
      allow(Rails.cache).to receive(:fetch).with("users_all", expires_in: 30.minutes).and_return([user, another_user])

      get :index

      expect(response).to be_successful
      expect(JSON.parse(response.body).size).to eq(2)
    end
  end

  describe 'GET #show' do
    it 'returns the user by id' do
      get :show, params: { id: user.id }

      expect(response).to be_successful
      expect(JSON.parse(response.body)['id']).to eq(user.id)
    end
  end

  describe 'POST #create' do
    context 'with valid parameters' do
      let(:valid_attributes) { { name: 'John Doe', email: 'john@example.com', phone: '1234567890' } }

      it 'creates a new user' do
        expect {
          post :create, params: { user: valid_attributes }
        }.to change(User, :count).by(1)

        expect(response).to have_http_status(:created)
        expect(JSON.parse(response.body)['name']).to eq('John Doe')
      end
    end

    context 'with invalid parameters' do
      let(:invalid_attributes) { { name: '', email: 'invalid_email', phone: '' } }

      it 'does not create a new user' do
        expect {
          post :create, params: { user: invalid_attributes }
        }.not_to change(User, :count)

        expect(response).to have_http_status(:unprocessable_entity)
        expect(JSON.parse(response.body)['errors']).to include("Name can't be blank")
      end
    end
  end

  describe 'PATCH/PUT #update' do
    context 'with valid parameters' do
      let(:valid_attributes) { { name: 'Updated Name' } }

      it 'updates the user' do
        patch :update, params: { id: user.id, user: valid_attributes }

        expect(response).to be_successful
        expect(JSON.parse(response.body)['name']).to eq('Updated Name')
      end
    end

    context 'with invalid parameters' do
      let(:invalid_attributes) { { name: '' } }

      it 'does not update the user' do
        patch :update, params: { id: user.id, user: invalid_attributes }

        expect(response).to have_http_status(:unprocessable_entity)
        expect(JSON.parse(response.body)['errors']).to include("Name can't be blank")
      end
    end
  end

  describe 'DELETE #destroy' do
    it 'deletes the user' do
      expect {
        delete :destroy, params: { id: user.id }
      }.to change(User, :count).by(-1)

      expect(response).to have_http_status(:no_content)
    end
  end
end

