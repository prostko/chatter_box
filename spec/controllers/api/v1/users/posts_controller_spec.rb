require 'rails_helper'

RSpec.describe Api::V1::Users::PostsController, type: :controller do
  let(:user) { create(:user) }

  before do
    sign_in(user)
  end

  describe 'GET #index' do
    it 'returns user posts with pagination' do
      post = create(:post)
      user.posts << post
      
      get :index, params: { user_id: user.id, page: 1, per_page: 10 }
      
      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)['posts']).to be_an(Array)
    end
  end

  describe 'GET #show' do
    it 'returns a specific user post' do
      post = create(:post)
      user.posts << post
      
      get :show, params: { user_id: user.id, id: post.id }
      
      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)['post']['id']).to eq(post.id)
    end
  end

  describe 'GET #new' do
    it 'returns a new post' do
      get :new, params: { user_id: user.id }
      
      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)['post']).to be_present
    end
  end

  describe 'POST #create' do
    it 'creates a new post' do
      post_params = { title: 'Test Post', body: 'Test body' }
      
      expect {
        post :create, params: { user_id: user.id, post: post_params }
      }.to change(Post, :count).by(1)
      
      expect(response).to have_http_status(:created)
    end

    it 'returns errors for invalid post' do
      post_params = { title: '', body: '' }
      
      post :create, params: { user_id: user.id, post: post_params }
      
      expect(response).to have_http_status(:unprocessable_entity)
      expect(JSON.parse(response.body)['errors']).to be_present
    end
  end

  describe 'PUT #update' do
    let(:post) { create(:post) }
    
    before do
      user.posts << post
    end

    it 'updates a post' do
      put_params = { title: 'Updated Title' }
      
      put :update, params: { user_id: user.id, id: post.id, post: put_params }
      
      expect(response).to have_http_status(:ok)
      expect(post.reload.title).to eq('Updated Title')
    end
  end

  describe 'DELETE #destroy' do
    let(:post) { create(:post) }
    
    before do
      user.posts << post
    end

    it 'soft deletes a post' do
      delete :destroy, params: { user_id: user.id, id: post.id }
      
      expect(response).to have_http_status(:ok)
      expect(post.reload.deleted_at).to be_present
    end
  end
end 