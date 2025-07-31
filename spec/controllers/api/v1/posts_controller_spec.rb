require 'rails_helper'

RSpec.describe Api::V1::PostsController, type: :controller do
  describe 'GET #index' do
    it 'returns posts with pagination' do
      post = create(:post)
      get :index, params: { page: 1, per_page: 10 }
      
      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)['posts']).to be_an(Array)
    end

    it 'sets X-Total-Count header on first request' do
      create(:post)
      get :index, params: { page: 1, per_page: 10 }
      
      expect(response.headers['X-Total-Count']).to eq(Post.count)
    end
  end

  describe 'GET #show' do
    it 'returns a specific post' do
      post = create(:post)
      get :show, params: { id: post.id }
      
      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)['post']['id']).to eq(post.id)
    end

    it 'returns 404 for non-existent post' do
      expect { get :show, params: { id: 999999 } }.to raise_error(ActiveRecord::RecordNotFound)
    end
  end
end 