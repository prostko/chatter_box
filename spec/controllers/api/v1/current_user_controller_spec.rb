require 'rails_helper'

RSpec.describe Api::V1::CurrentUserController, type: :controller do
  describe 'GET #show' do
    it 'returns current user' do
      user = create(:user)
      allow(Current).to receive(:user).and_return(user)
      
      get :show
      
      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)['user']['id']).to eq(user.id)
    end
  end
end 