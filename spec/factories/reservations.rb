# frozen_string_literal: true

FactoryBot.define do
  factory :reservation do
    table { nil }
    customer_name { "Customer 1" }
    customer_email { Faker::Internet.email }
    customer_phone { Faker::PhoneNumber.phone_number }
    reservation_date { Faker::Date.forward(days: 23) }
    party_size { 1 }
    status { "pending" }
    confirmation_code { "016" }
    user
  end
end
