# frozen_string_literal: true

class Api::V1::DashboardController < ApplicationController

  def index
    render json: {
      reservations_today: reservations_today,
      reservations_this_week: reservations_this_week,
      reservations_this_month: reservations_this_month,
      tables: tables,
      total_reservations: total_reservations,
      confirmed_reservations: confirmed_reservations,
      canceled_reservations: canceled_reservations,
      occupancy_rate_today: occupancy_rate_today
    }
  end

  private

  def reservations_today
    Reservation.where(reservation_date: Date.today.beginning_of_day..Date.today.end_of_day)
  end

  def reservations_this_week
    Reservation.where(reservation_date: Date.today.beginning_of_week..Date.today.end_of_week)
  end

  def reservations_this_month
    Reservation.where(reservation_date: Date.today.beginning_of_month..Date.today.end_of_month)
  end

  def tables
    Table.all
  end

  def total_reservations
    Reservation.count
  end

  def confirmed_reservations
    Reservation.where(status: 'confirmed').count
  end

  def canceled_reservations
    Reservation.where(status: 'canceled').count
  end

  def occupancy_rate_today
    reservations = reservations_today
    total_capacity = Table.sum(:capacity)
    occupied_capacity = reservations.sum { |r| r.table.capacity }
    (occupied_capacity.to_f / total_capacity * 100).round(2)
  end
end
