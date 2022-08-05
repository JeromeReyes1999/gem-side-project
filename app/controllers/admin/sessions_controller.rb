class Admin::SessionsController < Devise::SessionsController
  def create
    user = User.find_by_email(params[:admin_user][:email])

    if user.nil?
      flash[:notice] = "account doesn't exist"
      redirect_to action: :new
    elsif user.client?
      flash[:notice] = "you don't have permission"
      redirect_to action: :new
    else
      super
    end
  end
end
