# frozen_string_literal: true

require 'rails_helper'

RSpec.describe DashboardController, type: :request do
  let!(:table) { create(:table) }
  let!(:reservation_today) { create(:reservation, reservation_date: Date.today, table: table) }
  let!(:reservation_this_week) { create(:reservation, reservation_date: Date.today + 1.days, table: table) }
  let!(:reservation_this_month) { create(:reservation, reservation_date: Date.today + 10.days, table: table) }
  let!(:reservation_confirmed) { create(:reservation, status: 'confirmed', table: table) }
  let!(:reservation_canceled) { create(:reservation, status: 'canceled', table: table) }

  describe 'GET #index' do
    it 'returns a successful response' do
      get :index, params: {}, as: :json
      expect(response).to have_http_status(:success)
    end

    it 'returns the correct data' do
      get :index, params: {}, as: :json
      json_response = JSON.parse(response.body)

      expect(json_response['reservations_today'].size).to eq(1)
      expect(json_response['reservations_this_week'].size).to eq(2)
      expect(json_response['reservations_this_month'].size).to eq(3)
      expect(json_response['tables'].size).to eq(1)
      expect(json_response['total_reservations']).to eq(4)
      expect(json_response['confirmed_reservations']).to eq(2)
      expect(json_response['canceled_reservations']).to eq(1)
      expect(json_response['occupancy_rate_today']).to be_within(0.01).of(100.0)
    end
  end
end
