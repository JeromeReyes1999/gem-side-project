class Admin::BetListController < AdminController

  def index
    @bets = Bet.includes(:user, :item)
    @bets = @bets.where(serial_number: params[:serial_number]) if params[:serial_number].present?
    @bets = @bets.where(user: {email: params[:email]}) if params[:email].present?
    @bets = @bets.where(item: {name: params[:product_name]}) if params[:product_name].present?
    @bets = @bets.where(state: params[:state]) if params[:state].present?
    @bets = @bets.where(created_at: params[:from].to_datetime..params[:to].to_datetime) if params[:from].present? && params[:to].present?
  end
end