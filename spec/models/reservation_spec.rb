# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Reservation, type: :model do
  let(:user) { create(:user) }
  let(:table) { create(:table, user: user) }
  let(:reservation) { build(:reservation, user: user, table: table) }

  describe 'associations' do
    it { should belong_to(:table) }
    it { should belong_to(:user) }
  end

  describe 'validations' do
    it { should validate_presence_of(:customer_name) }
    it { should validate_presence_of(:customer_email) }
    it { should validate_presence_of(:customer_phone) }
    it { should validate_presence_of(:reservation_date) }
    it { should validate_presence_of(:party_size) }
    it { should validate_numericality_of(:party_size).is_greater_than(0) }
    it { should validate_presence_of(:status) }
    it { should validate_inclusion_of(:status).in_array(%w[pending confirmed canceled]) }
  end

  describe 'callbacks' do
    it 'generates a confirmation code before validation on create' do
      reservation.valid?
      expect(reservation.confirmation_code).not_to be_nil
    end

    it 'does not allow reservation date in the past' do
      reservation.reservation_date = 1.day.ago
      expect(reservation.valid?).to be_falsey
      expect(reservation.errors[:reservation_date]).to include("can't be in the past")
    end

    it 'ensures table availability' do
      create(:reservation, table: table, reservation_date: reservation.reservation_date)
      expect(reservation.valid?).to be_falsey
      expect(reservation.errors[:table]).to include('is already booked for the selected time')
    end
  end

  describe 'scopes' do
    it 'returns upcoming reservations' do
      future_reservation = create(:reservation, reservation_date: 2.days.from_now, user: user, table: table)
      expect(Reservation.upcoming).to include(future_reservation)
    end

    it 'returns past reservations' do
      past_reservation = create(:reservation, reservation_date: 5.day.ago, user: user, table: table)
      expect(Reservation.past).to include(past_reservation)
    end

    it 'returns reservations by status' do
      pending_reservation = create(:reservation, status: 'pending', user: user, table: table)
      expect(Reservation.by_status('pending')).to include(pending_reservation)
    end
  end
end
