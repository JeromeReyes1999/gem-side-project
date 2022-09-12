class Admin::InviteListController  < AdminController

  def index
    @users = User.where(role: :client).includes(:parent, :children).where.not(parent: nil)
    @users = @users.where(parent: {email: params[:parent_email]}) if params[:parent_email].present?
  end
end
