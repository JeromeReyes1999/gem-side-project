class Order < ApplicationRecord
  enum genre: [:deposit, :increase, :deduct, :bonus, :share]

  belongs_to :user
  belongs_to :offer, optional: true

  validates :amount, numericality: { greater_than: 0 }, if: :deposit?
  validates :amount, numericality: { greater_than_or_equal: 0 }, unless: :deposit?

  after_create :generate_serial_number

  include AASM
  aasm column: :state do
    state :pending, initial: true
    state :submitted, :cancelled, :paid

    event :submit do
      transitions from: :pending, to: :submitted
    end

    event :cancel do
      transitions from: [:submitted, :pending], to: :cancelled
      transitions from: :paid, to: :cancelled, after: :on_cancel_update_user_coin, guard: :coin_less_that_user_coins?
    end

    event :pay do
      transitions from: :submitted, to: :paid, after: :on_pay_update_user_coin
    end
  end

  def on_pay_update_user_coin
    if deduct?
      user.update(coins: user.coins - coin)
    else
      user.update(coins: user.coins + coin)
    end
  end

  def on_cancel_update_user_coin
    if deduct?
      user.update(coins: user.coins + coin)
    else
      user.update(coins: user.coins - coin)
    end
  end

  def increase_total_deposit
    user.update(total_deposit: user.total_deposit + amount) if deposit?
  end

  def deduct_total_deposit
    user.update(total_deposit: user.total_deposit - amount) if deposit?
  end

  def coin_less_that_user_coins?
    return true if (user.coins >= coin) && !deduct?
    errors.add(:base, "You deducted more coins than the user's total coins")
    false
  end

  def generate_serial_number
    ActiveRecord::Base.connection.execute("UPDATE `orders` SET `orders`.`serial_number` = CONCAT(DATE_FORMAT(CONVERT_TZ(orders.created_at, '+00:00', '+8:00'), '%y%m%d'),'-',#{id},'-',#{user.id},'-',
                                                    (SELECT LPAD(count(*), 4, 0)
                                                     FROM `orders` where `orders`.`user_id` = #{user.id}))
                                                     WHERE orders.id = #{id}")
  end
end