class City < ApplicationRecord
  validates_presence_of :code
  validates_presence_of :name
  belongs_to :province
  has_many :barangays
end
