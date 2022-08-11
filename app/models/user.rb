class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  validates :phone, phone: {allow_blank: true}

  mount_uploader :image, ImageUploader

  has_many :addresses

  has_many :children, class_name: "User", foreign_key: "parent_id"
  belongs_to :parent, class_name: "User", optional: true

  def admin?
    role == 'admin'
  end

  def client?
    role == 'client'
  end
end
