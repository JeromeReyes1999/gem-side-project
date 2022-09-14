class Users::InvitePeopleController < ApplicationController
  before_action :set_url
  before_action :generate_qr_code

  def invite_page
    @current_members = current_user.children_members
    @member_level = MemberLevel.order(:required_members).where('required_members > ?', current_user.children_members).first
    @members_before_level_up = @member_level.required_members - @current_members if @member_level.present?
  end

  private

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
      viewbox: true
    )
  end
end
