# spec/models/table_spec.rb

require 'rails_helper'

RSpec.describe Table, type: :model do

  it { should belong_to(:user) }

  it { should validate_presence_of(:name) }
  it { should validate_presence_of(:capacity) }
  it { should validate_presence_of(:location) }

  it { should validate_numericality_of(:capacity).is_greater_than(0) }

  it "is valid with valid attributes" do
    user = User.create(email: "test@example.com", password: "password")
    table = Table.new(name: "Mesa 1", capacity: 4, location: "Salão Principal", user: user)
    expect(table).to be_valid
  end

  it "is invalid without a name" do
    table = Table.new(capacity: 4, location: "Salão Principal")
    expect(table).to_not be_valid
    expect(table.errors[:name]).to include("can't be blank")
  end

  it "is invalid without capacity" do
    table = Table.new(name: "Mesa 1", location: "Salão Principal")
    expect(table).to_not be_valid
    expect(table.errors[:capacity]).to include("can't be blank")
  end

  it "is invalid without a location" do
    table = Table.new(name: "Mesa 1", capacity: 4)
    expect(table).to_not be_valid
    expect(table.errors[:location]).to include("can't be blank")
  end

  it "is invalid with capacity less than or equal to 0" do
    table = Table.new(name: "Mesa 1", capacity: 0, location: "Salão Principal")
    expect(table).to_not be_valid
    expect(table.errors[:capacity]).to include("must be greater than 0")
  end
end
