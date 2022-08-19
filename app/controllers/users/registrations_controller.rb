class Users::RegistrationsController < Devise::RegistrationsController

  layout "home_layout"

  def new
    super
    cookies[:promoter] = params[:promoter] unless cookies[:promoter]
  end

  def update
    user=params[:user]
    if user[:current_password].blank? && user[:password_confirmation].blank? && user[:password].blank?
      update_user
    else
      update_password
    end
  end

  def create
    params[:user][:parent_id] = User.find_by_email(cookies[:promoter])&.id
    super
  end

  private

  def sign_up_params
    params.require(:user).permit(:email, :parent_id, :password, :password_confirmation, :current_password)
  end

  def update_password
    if @user.update_with_password(user_password_params)
      flash[:notice] = "Successfully Updated"
      sign_in @user, :bypass => true
      redirect_to users_detail_path
    else
      redirect_to action: :edit
    end
  end

  def update_user
    if @user.update(user_details_params)
      flash[:notice] = "Successfully Updated"
      sign_in @user, :bypass => true
      redirect_to users_detail_path
    else
      redirect_to action: :edit
    end
  end

  def user_details_params
    params.require(:user).permit(:phone, :image, :username)
  end

  def user_password_params
    params.require(:user).permit(:phone, :image, :username, :password, :password_confirmation, :current_password)
  end

end