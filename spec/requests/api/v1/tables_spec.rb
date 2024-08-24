
# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::V1::TablesController, type: :request do
  let!(:user) { create(:user) }
  let!(:table) { create(:table, user: user) }
  let!(:tables) { create_list(:table, 5, user: user) }

  before do
    post '/login', params: { user: { email: user.email, password: user.password } }
    @jwt_token = response.headers['Authorization'].split(' ').last
  end


  describe "GET /api/v1/tables" do
    it "returns a list of tables" do
      get '/api/v1/tables', headers: { Authorization: "Bearer #{@jwt_token}" }
      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body).size).to eq(6)
    end
  end

  describe "GET /api/v1/tables/:id" do
    it "returns a specific table" do
      get "/api/v1/tables/#{table.id}", headers: { Authorization: "Bearer #{@jwt_token}" }
      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)["id"]).to eq(table.id)
    end

    it "returns a 404 if the table is not found" do
      get "/api/v1/tables/9999", headers: { Authorization: "Bearer #{@jwt_token}" }
      expect(response).to have_http_status(:not_found)
    end
  end

  describe "POST /api/v1/tables" do
    it "creates a new table" do
      table_params = { name: "Mesa Nova", capacity: 4, location: "Terraço" }
      post '/api/v1/tables', params: { table: table_params }, headers: { Authorization: "Bearer #{@jwt_token}" }
      expect(response).to have_http_status(:created)
      expect(JSON.parse(response.body)["name"]).to eq("Mesa Nova")
    end

    it "returns unprocessable_entity status if the table cannot be created" do
      post '/api/v1/tables', params: { table: { name: "" } }, headers: { Authorization: "Bearer #{@jwt_token}" }
      expect(response).to have_http_status(422)
    end
  end

  describe "PUT /api/v1/tables/:id" do
    it "updates an existing table" do
      put "/api/v1/tables/#{table.id}", params: { table: { name: "Mesa Atualizada" } }, headers: { Authorization: "Bearer #{@jwt_token}" }
      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)["name"]).to eq("Mesa Atualizada")
    end

    it "returns unprocessable_entity status if the table cannot be updated" do
      put "/api/v1/tables/#{table.id}", params: { table: { name: "" } }, headers: { Authorization: "Bearer #{@jwt_token}" }
      expect(response).to have_http_status(422)
    end
  end

  describe "DELETE /api/v1/tables/:id" do
    it "deletes an existing table" do
      expect {
        delete "/api/v1/tables/#{table.id}", headers: { Authorization: "Bearer #{@jwt_token}" }
      }.to change(Table, :count).by(-1)
      expect(response).to have_http_status(:no_content)
    end
  end
end
