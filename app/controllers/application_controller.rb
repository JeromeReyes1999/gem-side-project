class ApplicationController < ActionController::Base
  layout 'home_layout'
  before_action :set_banners

  def set_banners
    @banners = Banner.where('online_at <= ? AND offline_at > ?', Time.now, Time.now).active
  end
end
