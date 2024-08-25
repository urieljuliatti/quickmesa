# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::V1::ReservationsController, type: :request do
  let(:user) { create(:user) }
  let(:table) { create(:table, user: user) }
  let(:reservation) { create(:reservation, user: user, table: table) }
  let(:headers) { { 'Authorization' => "Bearer #{user.generate_jwt}" } }

  before do
    post '/login', params: { user: { email: user.email, password: user.password } }
    @jwt_token = response.headers['Authorization'].split(' ').last
  end

  describe "GET /api/v1/reservations" do
    it "returns a list of reservations" do
      create_list(:reservation, 3, user: user, table: table)
      get api_v1_reservations_path, headers: { Authorization: "Bearer #{@jwt_token}" }
      expect(response).to have_http_status(:ok)
      expect(json.size).to eq(3)
    end
  end

  describe "GET /api/v1/reservations/:id" do
    it "returns a reservation" do
      get api_v1_reservation_path(reservation), headers: { Authorization: "Bearer #{@jwt_token}" }
      expect(response).to have_http_status(:ok)
      expect(json['id']).to eq(reservation.id)
    end
  end

  describe "POST /api/v1/reservations" do
    let(:valid_attributes) do
      {
        reservation: {
          customer_name: "John Doe",
          customer_email: "john@example.com",
          customer_phone: "123456789",
          reservation_date: 2.days.from_now,
          party_size: 4,
          table_id: table.id
        }
      }
    end

    it "creates a new reservation" do
      expect {
        post api_v1_reservations_path, params: valid_attributes, headers: { Authorization: "Bearer #{@jwt_token}" }
      }.to change(Reservation, :count).by(1)

      expect(response).to have_http_status(:created)
      expect(json['status']).to eq('pending')
    end
  end

  describe "PUT /api/v1/reservations/:id" do
    let(:new_attributes) do
      {
        reservation: {
          customer_name: "Jane Doe",
          customer_email: "jane@example.com",
          party_size: 6
        }
      }
    end

    it "updates a reservation" do
      put api_v1_reservation_path(reservation), params: new_attributes, headers: { Authorization: "Bearer #{@jwt_token}" }
      reservation.reload
      expect(response).to have_http_status(:ok)
      expect(reservation.customer_name).to eq("Jane Doe")
      expect(reservation.party_size).to eq(6)
    end
  end

  describe "DELETE /api/v1/reservations/:id" do
    it "deletes a reservation" do
      reservation = create(:reservation, user: user, table: table)
      expect {
        delete api_v1_reservation_path(reservation), headers: { Authorization: "Bearer #{@jwt_token}" }
      }.to change(Reservation, :count).by(-1)
      expect(response).to have_http_status(:no_content)
    end
  end

  describe "POST /api/v1/reservations/:id/confirm" do
    it "confirms the reservation" do
      post confirm_api_v1_reservation_path(reservation), headers: { Authorization: "Bearer #{@jwt_token}" }
      reservation.reload
      expect(response).to have_http_status(:ok)
      expect(reservation.status).to eq('confirmed')
    end
  end

  describe "POST /api/v1/reservations/:id/cancel" do
    it "cancels the reservation" do
      post cancel_api_v1_reservation_path(reservation), headers: { Authorization: "Bearer #{@jwt_token}" }
      reservation.reload
      expect(response).to have_http_status(:ok)
      expect(reservation.status).to eq('canceled')
    end
  end

  def json
    JSON.parse(response.body)
  end
end
