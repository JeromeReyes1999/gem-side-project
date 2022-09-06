class Item < ApplicationRecord
  validates :image, :name, :quantity, :minimum_bets, :online_at, :offline_at, :start_at, presence: true
  validates :quantity, numericality: { greater_than_or_equal_to: 0 }
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

    event :start do
      transitions from: [:pending, :ended, :cancelled], to: :starting, after: :set_batch, guards: [:quantity_positive?, :offline_at_future?, :status_active?]
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
    entries = bets.batch_active_bets(batch_count)
    winning_bet = entries.sample
    winning_bet.win!
    entries.where.not(id: winning_bet.id).each {| bet | bet.lose!}
    winner = Winner.new(user: winning_bet.user, bet: winning_bet, item: winning_bet.item, batch_count: winning_bet.batch_count)
    winner.save!
  end

  def cancel_bet
    bets.where(batch_count: batch_count).where.not(state: :cancelled).each {| bet | bet.cancel!}
  end

  def set_batch
    update(quantity: quantity - 1, batch_count: batch_count + 1)
  end

  def quantity_positive?
    return true if quantity > 0
    errors.add(:base, 'No item left')
    false
  end

  def offline_at_future?
    return true if offline_at > Time.now
    errors.add(:base, 'The item is currently offline')
    false
  end

  def status_active?
    return true if self.status == 'active'
    errors.add(:base, 'The item is inactive')
    false
  end
end
