class Users::FeedbacksController < ApplicationController
  before_action :set_winner, only: :show

  def show; end

  def index
    @winners = Winner.includes(:user).published
  end

  private

  def set_winner
    @winner = Winner.includes(:user).find(params[:id])
  end
end