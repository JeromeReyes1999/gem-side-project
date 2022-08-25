class Admin::WinnersController < AdminController
    def index
      @winners = Winner.includes(:user, :item, :bet)
      @winners = @winners.where(bet: {serial_number: params[:serial_number]}) if params[:serial_number].present?
      @winners = @winners.where(user: {email: params[:email]}) if params[:email].present?
      @winners = @winners.where(item: {genre: params[:product_name]}) if params[:product_name].present?
      @winners = @winners.where(state: params[:state]) if params[:state].present?
      @winners = @winners.where(created_at: params[:from].to_datetime..params[:to].to_datetime) if params[:from].present? && params[:to].present?
    end

    def transition
      winner = Winner.find(params[:id])
      winner.send(params[:event].concat('!'))
      redirect_to request.referrer
    end
end