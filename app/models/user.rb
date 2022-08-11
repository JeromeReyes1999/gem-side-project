class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  validates :phone, phone: {allow_blank: true}

  mount_uploader :image, ImageUploader

  has_many :addresses

  def admin?
    role == 'admin'
  end

  def client?
    role == 'client'
  end
end
