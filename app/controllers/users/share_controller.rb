class Users::ShareController < ApplicationController
  before_action :authenticate_user!
  before_action :set_winner

  def show; end

  def update
    if @winner.share! && @winner.update(winner_params)
      flash[:notice] = "Successfully updated!"
    else
      flash[:alert] = "failed to share!"
    end
    redirect_to users_detail_path(activities: 'winning')
  end

  private

  def set_winner
    @winner = Winner.where(user: current_user).find(params[:id])
  end

  def winner_params
    params.require(:winner).permit(:comment, :picture)
  end
end