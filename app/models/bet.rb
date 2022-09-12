class Bet < ApplicationRecord
  validates :coins, numericality: { greater_than: 0 }
  belongs_to :user
  belongs_to :item
  after_create :generate_serial_number, :deduct_user_coin
  has_many :winners
  scope :batch_active_bets, -> (batch) {where(batch_count: batch).betting}

  include AASM
  aasm column: :state do
    state :betting, initial: true
    state :won, :lost, :cancelled

    event :win do
      transitions from: :betting, to: :won
    end
    event :lose do
      transitions from: :betting, to: :lost
    end

    event :cancel, after: :refund do
      transitions from: :betting, to: :cancelled
    end
  end

  def refund
    user.update(coins: user.coins + 1)
  end

  def deduct_user_coin
    user.update(coins: user.coins - 1)
  end

  def generate_serial_number
  ActiveRecord::Base.connection.execute("UPDATE `bets` SET `bets`.`serial_number` = CONCAT(DATE_FORMAT(CONVERT_TZ(bets.created_at, '+00:00', '+8:00'), '%y%m%d'),'-',#{item.id},'-',#{item.batch_count},'-',
                                                  (SELECT LPAD(count(*), 4, 0)
                                                   FROM `bets` where `bets`.`batch_count` = #{item.batch_count} AND `bets`.`item_id` = #{item.id}))
                                                   WHERE bets.id = #{id}")
  end

end
