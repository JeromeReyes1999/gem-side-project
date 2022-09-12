class NewsTicker < ApplicationRecord
  enum status: [:active, :inactive]
  belongs_to :admin, class_name: 'User'
  default_scope { where(deleted_at: nil) }

  def destroy
    update(deleted_at: Time.current)
  end
end
