class Category < ApplicationRecord
  validates_presence_of :name
  has_many :items

  default_scope { where(deleted_at: nil) }

  def destroy
    unless self.items.present?
      update(deleted_at: Time.current)
    else
      errors.add(:base, "Can't delete a category that's currently used in an item")
      return false
    end
  end
end
