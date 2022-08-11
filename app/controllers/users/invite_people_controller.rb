class Users::InvitePeopleController < ApplicationController
  require "rqrcode"
  before_action :set_url
  before_action :generate_qr_code

  layout 'home_layout'

  def set_url
    if current_user
      @url="#{request.base_url}/users/sign_up?promoter=#{current_user.email}"
    else
      @url="#{request.base_url}/users/sign_up"
    end
  end

  def generate_qr_code
    qr = RQRCode::QRCode.new(@url)

    @svg = qr.as_svg(
      color: "000",
      shape_rendering: "crispEdges",
      module_size: 11,
      standalone: true,
      use_path: true,
    )
  end
end