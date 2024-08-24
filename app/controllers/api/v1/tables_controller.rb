# frozen_string_literal: true

module Api
  module V1
    class TablesController < ApplicationController
      before_action :set_table, only: [:show, :update, :destroy]
      before_action :authenticate_user!

      def index
        @tables = Table.all
        render json: @tables
      end

      def show
        render json: @table
      end

      def create
        @table = Table.new(table_params)
        @table.user = current_user
        if @table.save
          render json: @table, status: :created
        else
          render json: @table.errors, status: :unprocessable_entity
        end
      end

      def update
        if @table.update(table_params)
          render json: @table
        else
          render json: @table.errors, status: :unprocessable_entity
        end
      end

      def destroy
        @table.destroy
        head :no_content
      end

      private

      def set_table
        @table = Table.find(params[:id])
      end

      def table_params
        params.require(:table).permit(:name, :capacity, :location, :user_id)
      end
    end
  end
end
