# frozen_string_literal: true

class Reservation < ApplicationRecord
  # Associations
  belongs_to :table
  belongs_to :user

  # Validations
  validates :customer_name, presence: true
  validates :customer_email, presence: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :customer_phone, presence: true
  validates :reservation_date, presence: true
  validates :party_size, presence: true, numericality: { greater_than: 0 }
  validates :status, presence: true, inclusion: { in: %w[pending confirmed canceled] }

  # Callbacks
  before_validation :generate_confirmation_code, on: :create
  validate :reservation_date_cannot_be_in_the_past
  validate :ensure_table_availability

  # Scopes
  scope :upcoming, -> { where('reservation_date >= ?', Time.current) }
  scope :past, -> { where('reservation_date < ?', Time.current) }
  scope :by_status, ->(status) { where(status: status) }

  private

  # Generates a unique confirmation code for the reservation
  def generate_confirmation_code
    self.confirmation_code ||= loop do
      code = SecureRandom.hex(4).upcase
      break code unless Reservation.exists?(confirmation_code: code)
    end
  end

  # Validates that the reservation date is not in the past
  def reservation_date_cannot_be_in_the_past
    return if reservation_date.blank?
    if reservation_date < Time.current
      errors.add(:reservation_date, "can't be in the past")
    end
  end

  # Validates that the table is available for the specified date and time
  def ensure_table_availability
    return if reservation_date.blank? || table.blank?

    overlapping_reservations = table.reservations.where.not(id: id).where(
      reservation_date: reservation_date.beginning_of_hour..reservation_date.end_of_hour
    )

    if overlapping_reservations.exists?
      errors.add(:table, 'is already booked for the selected time')
    end
  end
end
