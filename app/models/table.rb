# frozen_string_literal: true

class Table < ApplicationRecord
  belongs_to :user
  has_many :reservations, dependent: :destroy

  validates_presence_of :name, :capacity, :location
  validates :capacity, numericality: { greater_than: 0 }
end
