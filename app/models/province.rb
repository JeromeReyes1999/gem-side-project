class Province < ApplicationRecord
  validates_presence_of :code
  validates_presence_of :name
  has_many :city
  belongs_to :region
end
