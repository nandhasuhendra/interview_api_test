require 'rails_helper'

RSpec.describe Api::V1::JobsController, type: :controller do
  let(:user) { create(:user) }
  let(:job) { create(:job, user: user) }

  describe 'GET #index' do
    context 'when user_id is passed' do
      it 'returns jobs for the specific user from the cache' do
        # Use cache mock for testing the cache behavior
        Rails.cache.clear # clear cache before running test
        job1 = create(:job, user: user)
        job2 = create(:job, user: user)
        
        # Stub the cache to return an array of jobs when called
        allow(Rails.cache).to receive(:fetch).with("jobs_user_#{user.id}", expires_in: 30.minutes).and_return([job1, job2])

        get :index, params: { user_id: user.id }

        expect(response).to be_successful
        expect(JSON.parse(response.body).size).to eq(2)
      end
    end

    context 'when no user_id is passed' do
      it 'returns all jobs from the cache' do
        job1 = create(:job)
        job2 = create(:job)

        # Stub the cache to return an array of all jobs
        allow(Rails.cache).to receive(:fetch).with("jobs_all", expires_in: 30.minutes).and_return([job1, job2])

        get :index

        expect(response).to be_successful
        expect(JSON.parse(response.body).size).to eq(2)
      end
    end
  end

  describe 'GET #show' do
    it 'returns the requested job' do
      get :show, params: { id: job.id }

      expect(response).to be_successful
      expect(JSON.parse(response.body)['id']).to eq(job.id)
    end
  end

  describe 'POST #create' do
    context 'with valid parameters' do
      it 'creates a new job' do
        valid_attributes = { title: 'New Job', description: 'Description', status: 'pending', user_id: user.id }

        post :create, params: { job: valid_attributes }

        expect(response).to have_http_status(:created)
        expect(Job.count).to eq(1)
      end
    end

    context 'with invalid parameters' do
      it 'does not create a new job' do
        invalid_attributes = { title: '', description: '', status: 'active', user_id: user.id }

        post :create, params: { job: invalid_attributes }

        expect(response).to have_http_status(:unprocessable_entity)
        expect(JSON.parse(response.body)['errors']).to include("Title can't be blank")
      end
    end
  end

  describe 'PATCH/PUT #update' do
    context 'with valid parameters' do
      it 'updates the requested job' do
        updated_attributes = { title: 'Updated Job' }

        put :update, params: { id: job.id, job: updated_attributes }

        expect(response).to be_successful
        expect(job.reload.title).to eq('Updated Job')
      end
    end

    context 'with invalid parameters' do
      it 'does not update the job' do
        invalid_attributes = { title: '' }

        put :update, params: { id: job.id, job: invalid_attributes }

        expect(response).to have_http_status(:unprocessable_entity)
        expect(JSON.parse(response.body)['errors']).to include("Title can't be blank")
      end
    end
  end

  describe 'DELETE #destroy' do
    it 'destroys the requested job' do
      delete :destroy, params: { id: job.id }

      expect(response).to have_http_status(:no_content)
      expect(Job.count).to eq(0)
    end
  end
end

