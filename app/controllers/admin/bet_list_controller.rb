class Admin::BetListController < AdminController

  def index
    @bets = Bet.includes(:user, :item)
    if params['bet'].present?
      @bets = @bets.where(name: params['bet'])
    end
  end

end
