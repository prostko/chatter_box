require 'rails_helper'

RSpec.describe Api::V1::Posts::RatingsController, type: :controller do
  describe 'GET #index' do
    let(:post) { create(:post) }

    it 'returns cached rating data' do
      cached_rating = create(:post_rating, post: post, rating: 4)
      cached_rating = create(:post_rating, post: post, rating: 5)

      PersistAveragePostRating.new(post.id).call!
      
      get :index, params: { post_id: post.id }
      
      expect(response).to have_http_status(:ok)
      json_response = JSON.parse(response.body)
      expect(json_response['average_rating']).to eq(4.5)
      expect(json_response['rating_count']).to eq(2)
    end

    it 'returns default values when no cached rating exists' do
      PersistAveragePostRating.new(post.id).call!

      get :index, params: { post_id: post.id }
      
      expect(response).to have_http_status(:ok)
      json_response = JSON.parse(response.body)
      expect(json_response['average_rating']).to eq(0.0)
      expect(json_response['rating_count']).to eq(0)
    end
  end
end 