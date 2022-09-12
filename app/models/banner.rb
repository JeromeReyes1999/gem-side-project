class Banner < ApplicationRecord
  validates :preview, :status, :online_at, :offline_at, presence: true
  enum status: [:active, :inactive]
  default_scope { where(deleted_at: nil) }

  def destroy
    update(deleted_at: Time.current)
  end

  mount_uploader :preview, ImageUploader
end
