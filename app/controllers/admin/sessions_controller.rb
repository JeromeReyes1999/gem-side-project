class Admin::SessionsController < Devise::SessionsController

  def create
    user = User.find_for_authentication(email: params[:admin_user][:email])
    if user&.client? && user&.valid_password?(params[:admin_user][:password])
      flash[:notice] = "You don't have permission"
      redirect_to action: :new
    else
      super
    end
  end
end
