class Table < ApplicationRecord
  belongs_to :user
  validates_presence_of :name, :capacity, :location
  validates :capacity, numericality: { greater_than: 0 }
end
