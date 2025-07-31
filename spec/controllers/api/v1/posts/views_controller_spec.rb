require 'rails_helper'

RSpec.describe Api::V1::Posts::ViewsController, type: :controller do
  describe 'POST #create' do
    let(:post_record) { create(:post) }

    it 'persists view count' do      
      post :create, params: { post_id: post_record.id }
      
      expect(response).to have_http_status(:ok)
    end
  end

  describe 'GET #index' do
    let(:post_record) { create(:post) }

    it 'returns view count' do
      cached_view_count = create(:post_view_count, post: post_record, view_count: 42)
      
      get :index, params: { post_id: post_record.id }
      
      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)['view_count']).to eq(42)
    end

    it 'returns 0 when no cached view count exists' do
      get :index, params: { post_id: post_record.id }
      
      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)['view_count']).to eq(0)
    end
  end
end 