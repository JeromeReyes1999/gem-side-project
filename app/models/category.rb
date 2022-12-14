class Category < ApplicationRecord
  validates_presence_of :name, :sort
  has_many :items
  validates :sort, numericality: { greater_than: 0 }
  validates :sort, uniqueness: true

  default_scope { order(:sort).where(deleted_at: nil) }

  def destroy
    if self.items.present?
      errors.add(:base, "Can't delete a category that's currently used in an item")
      return false
    else
      update(deleted_at: Time.current)
    end
  end
end
