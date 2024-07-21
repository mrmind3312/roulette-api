require 'rails_helper'

RSpec.describe 'User Authentication', type: :request do  
  describe 'POST /api/auth/login' do
    let(:user) { FactoryBot.create(:user, email: "developer@recorrido.cl", password: "password") }

    it 'authenticates the user and returns a JWT token in the Authorization header' do
      post '/api/auth/login', params: {
        user: {
          email: user.email,
          password: user.password
        }
      }

      expect(response).to have_http_status(:success)
      expect(response.headers['Authorization']).to be_present
      expect(response.headers['Authorization']).to start_with('Bearer ')
    end

    it 'returns an error when email is incorrect' do
      post '/api/auth/login', params: {
        user: {
          email: "wrong_email@developer.cl",
          password: user.password
        }
      }

      expect(response).to have_http_status(:unauthorized)
      expect(response_body).to include("error")
    end

    it 'returns an error when password is incorrect' do
      post '/api/auth/login', params: {
        user: {
          email: user.email,
          password: "wrong_password"
        }
      }

      expect(response).to have_http_status(:unauthorized)
      expect(response_body).to include("error")
    end
  end
end

def response_body
  JSON.parse(response.body)
end
