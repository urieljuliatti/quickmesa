# frozen_string_literal: true

module Api
  module V1
    class ReservationsController < ApplicationController
      before_action :set_reservation, only: [:show, :update, :destroy, :confirm, :cancel]
      before_action :authenticate_user!

      def index
        @reservations = Reservation.all
        render json: @reservations
      end

      def show
        render json: @reservation
      end

      def create
        @reservation = current_user.reservations.build(reservation_params)
        @reservation.status = 'pending'
        @reservation.user = current_user

        if @reservation.save
          render json: @reservation, status: :created
        else
          render json: @reservation.errors, status: :unprocessable_entity
        end
      end

      def update
        if @reservation.update(reservation_params)
          render json: @reservation
        else
          render json: @reservation.errors, status: :unprocessable_entity
        end
      end

      def destroy
        @reservation.destroy
        head :no_content
      end

      def confirm
        if @reservation.update(status: 'confirmed')
          render json: @reservation, status: :ok
        else
          render json: @reservation.errors, status: :unprocessable_entity
        end
      end

      def cancel
        if @reservation.update(status: 'canceled')
          render json: @reservation, status: :ok
        else
          render json: @reservation.errors, status: :unprocessable_entity
        end
      end

      private

      def set_reservation
        @reservation = Reservation.find(params[:id])
      end

      def reservation_params
        params.require(:reservation).permit(:customer_name, :customer_email, :customer_phone, :reservation_date, :party_size, :status, :table_id, :user_id)
      end
    end
  end
end
