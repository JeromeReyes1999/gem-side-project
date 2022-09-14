class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  validates :phone, phone: {allow_blank: true}

  has_many :orders

  mount_uploader :image, ImageUploader
  has_many :winners
  has_many :addresses
  has_many :bets
  has_many :children, class_name: "User", foreign_key: "parent_id"
  belongs_to :parent, class_name: "User", optional: true, counter_cache: :children_members
  has_many :news_tickers, foreign_key: "admin_id"
  belongs_to :member_level, optional: true
  after_create :upgrade_parent

  def upgrade_parent
    return if parent.blank?
    parent_member_level = MemberLevel.all.find_by(required_members: parent.children_members)
    if parent_member_level.present?
      parent.update(member_level: parent_member_level, coins: parent.coins + parent_member_level.coins)
    end
  end

  def admin?
    role == 'admin'
  end

  def client?
    role == 'client'
  end


end
