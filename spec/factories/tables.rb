FactoryBot.define do
  factory :table do
    user
    name { "Table 1" }
    capacity { 1 }
    location { "Outside" }
  end
end
