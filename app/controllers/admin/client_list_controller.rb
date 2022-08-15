class Admin::ClientListController < AdminController
  layout "dashboard_layout"

  def index
    @users= User.includes(:parent).where(role: :client)
  end
end
