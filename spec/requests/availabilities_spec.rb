require 'rails_helper'

RSpec.describe 'User Availabilities', type: :request do
  let(:user) { FactoryBot.create(:user) }
  let(:catalog_hour) { FactoryBot.create(:catalog_hour) }
  let(:token) do
    post '/api/auth/login', params: {
      user: {
        email: user.email,
        password: user.password
      }
    }

    response.headers['authorization']
  end

  before do
    # Ensure the database is clean before each test
    DatabaseCleaner.clean
  end

  describe 'POST /api/v1/users/:id/availabilities' do
    it 'creates a new availability' do
      post "/api/v1/users/#{user.id}/availabilities",
           params: {
             day: 1,
             week: 1,
             month: 1,
             year: 2024,
             available: true,
             catalog_hours_id: catalog_hour.id
           }.to_json,
           headers: {
             'Authorization' => token,
             'Content-Type' => 'application/json'
           }

      expect(response).to have_http_status(:created)
      expect(response.content_type).to include('application/json')

      created_availability = JSON.parse(response.body)
      expect(created_availability).to include(
        'day' => 1,
        'week' => 1,
        'month' => 1,
        'year' => 2024,
        'available' => true,
        'catalog_hours_id' => catalog_hour.id
      )
    end
  end

  describe 'GET /api/v1/users/:id/availabilities' do
    context 'when there are availabilities' do
      before do
        post "/api/v1/users/#{user.id}/availabilities",
             params: {
               day: 1,
               week: 1,
               month: 1,
               year: 2024,
               available: true,
               catalog_hours_id: catalog_hour.id
             }.to_json,
             headers: {
               'Authorization' => token,
               'Content-Type' => 'application/json'
             }
      end

      it 'returns the list of availabilities' do
        get "/api/v1/users/#{user.id}/availabilities", headers: { 'Authorization' => token }

        expect(response).to have_http_status(:success)
        expect(response.content_type).to include('application/json')
        expect(response_body).to be_an(Array)
        expect(response_body.first).to include(
          'id', 'day', 'week', 'month', 'year', 'available', 'created_at',
          'updated_at', 'users_id', 'services_id', 'catalog_hours_id', 'start_at',
          'end_at', 'service', 'user'
        )
      end
    end

    context 'when there are no availabilities' do
      it 'returns an empty list' do
        get "/api/v1/users/#{user.id}/availabilities", headers: { 'Authorization' => token }

        expect(response).to have_http_status(:success)
        expect(response.content_type).to include('application/json')
        expect(response_body).to eq([])
      end
    end
  end

  def response_body
    JSON.parse(response.body)
  end
end
