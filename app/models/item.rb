class Item < ApplicationRecord
  validates :image, :name, :quantity, :minimum_bets, :online_at, :offline_at, :start_at, presence: true
  enum status: [:active, :inactive]
  validates :quantity, numericality: { greater_than: 0 }
  validates :minimum_bets, numericality: { greater_than: 0 }

  belongs_to :category
  has_many :bets

  mount_uploader :image, ImageUploader
  default_scope { where(deleted_at: nil) }

  def destroy
    update(deleted_at: Time.current)
  end

  include AASM
  aasm column: :state do
    state :pending, initial: true
    state :starting, :paused, :ended, :cancelled

    event :start do
      transitions from: [:pending, :ended, :cancelled], to: :starting, after: :set_batch, guards: [:quantity_positive?, :offline_at_future?, :active?]
      transitions from: :paused, to: :starting
    end

    event :pause do
      transitions from: :starting, to: :paused
    end

    event :end do
      transitions from: :starting, to: :ended
    end

    event :cancel do
      transitions from: [:starting, :paused], to: :cancelled
    end
  end

  def set_batch
    update_columns(quantity: self.quantity - 1, batch_count: self.batch_count + 1)
  end

  def quantity_positive?
    quantity > 0
  end

  def offline_at_future?
    offline_at > Time.now
  end
end
