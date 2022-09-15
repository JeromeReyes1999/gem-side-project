class NewsTicker < ApplicationRecord
  validates_presence_of :content, :status, :sort
  enum status: [:active, :inactive]
  belongs_to :admin, class_name: 'User'

  validates :sort, numericality: { greater_than: 0 }
  validates :sort, uniqueness: true

  default_scope { order(:sort).where(deleted_at: nil) }

  def destroy
    update(deleted_at: Time.current)
  end
end
