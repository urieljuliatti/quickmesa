# frozen_string_literal: true

FactoryBot.define do
  factory :table do
    name { "Table 1" }
    capacity { 1 }
    location { 'Outside' }
    user
  end
end
