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
    build_resource(sign_up_params)
    resource.parent_id = User.find_by_email(cookies[:promoter])&.id
    resource.save
    yield resource if block_given?
    if resource.persisted?
      if resource.active_for_authentication?
        set_flash_message! :notice, :signed_up
        sign_up(resource_name, resource)
        respond_with resource, location: after_sign_up_path_for(resource)
      else
        set_flash_message! :notice, :"signed_up_but_#{resource.inactive_message}"
        expire_data_after_sign_in!
        respond_with resource, location: after_inactive_sign_up_path_for(resource)
      end
    else
      clean_up_passwords resource
      set_minimum_password_length
      respond_with resource
    end
  end

  private

  def sign_up_params
    params.require(:user).permit(:email, :password, :password_confirmation, :current_password)
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