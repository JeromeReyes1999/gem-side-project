class MemberLevel < ApplicationRecord
  validates :level, :required_members, :coins, presence: true
  validates :coins, :required_members, numericality: { greater_than: 0 }
  validates :required_members, uniqueness: true
  has_many :users
end
