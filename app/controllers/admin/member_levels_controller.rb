class Admin::MemberLevelsController < AdminController
  before_action :set_member_level, only: [:edit, :update, :destroy]

  def index
    @member_levels= MemberLevel.order(:required_members)
  end

  def new
    @member_level = MemberLevel.new
  end

  def edit; end

  def update
    if @member_level.update(member_level_params)
      flash[:notice] = "Successfully updated!"
      redirect_to admin_member_levels_path
    else
      render :edit
    end
  end

  def destroy
    if @member_level.destroy
      flash[:notice] = "Successfully deleted!"
    else
      flash[:alert] = @member_level.errors.full_messages.join(', ')
    end
    redirect_to admin_member_levels_path
  end

  def create
    @member_level = MemberLevel.new(member_level_params)
    if @member_level.save
      flash[:notice] = "Successfully created!"
      redirect_to admin_member_levels_path
    else
      render :new
    end
  end

  private

  def member_level_params
    params.require(:member_level).permit(:level, :required_members , :coins)
  end

  def set_member_level
    @member_level = MemberLevel.find(params[:id])
  end
end
