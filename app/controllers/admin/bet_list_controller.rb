class Admin::BetListController < AdminController
  before_action :set_bet, only: :cancel

  def index
    @bets = Bet.includes(:user, :item)
    @bets = @bets.where(serial_number: params[:serial_number]) if params[:serial_number].present?
    @bets = @bets.where(user: {email: params[:email]}) if params[:email].present?
    @bets = @bets.where(item: {name: params[:product_name]}) if params[:product_name].present?
    @bets = @bets.where(state: params[:state]) if params[:state].present?
    @bets = @bets.where(created_at: params[:from].to_datetime..params[:to].to_datetime) if params[:from].present? && params[:to].present?
  end

  def cancel
      begin
        @bet.cancel!
        flash[:notice] = "the bet is cancelled"
      rescue => e
        flash[:alert] = 'transition failed!'
      end
    redirect_to request.referer
  end
  private

  def set_bet
    @bet = Bet.find(params[:bet_list_id])
  end
end
