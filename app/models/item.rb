class Item < ApplicationRecord
  validates :image, :name, :quantity, :minimum_bets, :online_at, :offline_at, :start_at, presence: true
  validates :quantity, numericality: { greater_than: 0 }
  validates :minimum_bets, numericality: { greater_than: 0 }
  enum status: [:active, :inactive]

  belongs_to :category
  has_many :bets
  has_many :winners

  mount_uploader :image, ImageUploader
  default_scope { where(deleted_at: nil) }

  def destroy
    if self.bets.present?
      errors.add(:base, "Can't delete an item that has bet on it")
      return false
    else
      update(deleted_at: Time.current)
    end
  end

  include AASM
  aasm column: :state do
    state :pending, initial: true
    state :starting, :paused, :ended, :cancelled

    event :start, error: :add_error do
      transitions from: [:pending, :ended, :cancelled], to: :starting, after: :set_batch, guards: [:quantity_positive?, :offline_at_future?, :active?]
      transitions from: :paused, to: :starting
    end

    event :pause do
      transitions from: :starting, to: :paused
    end

    event :end do
      transitions from: [:starting, :paused], to: :ended, after: :draw_winner, guard: :minimum_bets_reached?
    end

    event :cancel, after: [:cancel_bet, :return_item]  do
      transitions from: [:starting, :paused], to: :cancelled
    end
  end

  def return_item
    update(quantity: quantity + 1)
  end

  def minimum_bets_reached?
    bets.where(batch_count: batch_count).count >= minimum_bets
  end

  def draw_winner
    entries = bets.where(batch_count: batch_count).where.not(state: :cancelled)
    winning_bet = entries.sample
    winning_bet.win!
    entries.where.not(id: winning_bet.id).update_all(state: :lost)
    #if callback is needed in later issues, use this: entries.where.not(id: winning_bet.id).each {| bet | bet.lost!}
    winner = Winner.new(user: winning_bet.user, bet: winning_bet, item: winning_bet.item, batch_count: winning_bet.batch_count, address: winning_bet.user.addresses.find_by(is_default: true))
    winner.save!
  end

  def cancel_bet
    bets.where(batch_count: batch_count).each {| bet | bet.cancel!}
  end

  def set_batch
    update_columns(quantity: self.quantity - 1, batch_count: self.batch_count + 1)
  end

  def quantity_positive?
    quantity > 0
  end

  def add_error
    errors.add(:base, 'The item is currently offline') unless offline_at_future?
    errors.add(:base, 'No item left') unless quantity_positive?
    errors.add(:base, 'The item is inactive') unless active?
    return false
  end

  def offline_at_future?
    offline_at > Time.now
  end
end
