class Banner < ApplicationRecord
  validates :preview, :status, :online_at, :offline_at, :sort, presence: true
  validates :sort, numericality: { greater_than: 0 }
  validates :sort, uniqueness: true

  enum status: [:active, :inactive]

  default_scope { order(:sort).where(deleted_at: nil) }

  def destroy
    update(deleted_at: Time.current)
  end

  mount_uploader :preview, ImageUploader
end
