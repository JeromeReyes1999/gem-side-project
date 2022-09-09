class Admin::UsersController < AdminController
  def index
    @users= User.includes(:parent).where(role: :client)
  end
end
