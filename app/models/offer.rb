class Offer < ApplicationRecord
  validates :image, :name, :genre, :status, :amount, :coins, presence: true
  validates :amount, :coins, numericality: { greater_than: 0 }
  enum status: [:active, :inactive]
  enum genre: [:one_time, :monthly, :weekly, :daily, :regular]
  has_many :order
  mount_uploader :image, ImageUploader
end
