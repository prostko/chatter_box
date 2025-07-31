require 'rails_helper'

RSpec.describe Api::V1::Users::RatingsController, type: :controller do
  let(:user) { create(:user) }
  let(:post_record) { create(:post) }

  before do
    sign_in(user)
  end

  describe 'GET #show' do
    it 'returns existing rating' do
      rating = create(:post_rating, user: user, post: post_record)
      
      get :show, params: { user_id: user.id, post_id: post_record.id }
      
      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)['rating']['id']).to eq(rating.id)
    end

    it 'returns new rating if none exists' do
      get :show, params: { user_id: user.id, post_id: post_record.id }
      
      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)['rating']['id']).to be_nil
    end
  end

  describe 'POST #create' do
    it 'creates a new rating' do
      expect {
        post :create, params: { user_id: user.id, post_id: post_record.id, rating: 5 }
      }.to change(Post::Rating, :count).by(1)
      
      expect(response).to have_http_status(:created)
    end
  end

  describe 'PUT #update' do
    it 'updates existing rating' do
      rating = create(:post_rating, user: user, post: post_record, rating: 3)
      
      put :update, params: { user_id: user.id, post_id: post_record.id, rating: 5 }
      
      expect(response).to have_http_status(:ok)
      expect(rating.reload.rating).to eq(5)
    end

    it 'returns 404 for non-existent rating' do
      expect { put :update, params: { user_id: user.id, post_id: post_record.id, rating: 5 } }.to raise_error(ActiveRecord::RecordNotFound)
    end
  end
end 