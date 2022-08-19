class AdminController < ApplicationController
  layout 'dashboard_layout'

  before_action :authenticate_admin_user!
end