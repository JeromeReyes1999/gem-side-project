class Order < ApplicationRecord
  enum genre: [:deposit, :increase, :deduct, :bonus, :share, :member_level]
  validates :remarks, presence: true, if: :genre_has_remarks?
  belongs_to :user
  belongs_to :offer, optional: true

  validates :coin, numericality: { greater_than: 0 }

  after_create :generate_serial_number

  include AASM
  aasm column: :state do
    state :pending, initial: true
    state :submitted, :cancelled, :paid

    event :submit do
      transitions from: :pending, to: :submitted, guard: :deposit?
    end

    event :cancel do
      transitions from: :submitted, to: :cancelled, guards: [:deposit?, :on_cancel_check_coin], after: [:deduct_total_deposit, :on_cancel_update_user_coin]
      transitions from: :paid, to: :cancelled, guards: [:genre_admin_operable?,:on_cancel_check_coin], after: :on_cancel_update_user_coin
      transitions from: :pending, to: :cancelled
    end

    event :pay, after: :on_pay_update_user_coin do
      transitions from: :pending, to: :paid, guards: [:genre_admin_operable?, :on_pay_check_coin]
      transitions from: :submitted, to: :paid, guard: :deposit?, after: :increase_total_deposit
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
    user.update(total_deposit: user.total_deposit + amount)
  end

  def deduct_total_deposit
    user.update(total_deposit: user.total_deposit - amount)
  end

  def on_cancel_check_coin
    return true if deduct?
    coin_less_that_user_coins?
  end

  def on_pay_check_coin
    return true unless deduct?
    coin_less_that_user_coins?
  end

  def coin_less_that_user_coins?
     return true if (user.coins >= coin)
     errors.add(:base, "coins to be deducted should be greater than user's coins")
     false
  end

  def genre_admin_operable?
    [increase?, deduct?, bonus?, member_level?].any?
  end

  def genre_has_remarks?
    [increase?, deduct?, bonus?].any?
  end

  def generate_serial_number
    ActiveRecord::Base.connection.execute("UPDATE `orders` SET `orders`.`serial_number` = CONCAT(DATE_FORMAT(CONVERT_TZ(orders.created_at, '+00:00', '+8:00'), '%y%m%d'),'-',#{id},'-',#{user.id},'-',
                                                    (SELECT LPAD(count(*), 4, 0)
                                                     FROM `orders` where `orders`.`user_id` = #{user.id}))
                                                     WHERE orders.id = #{id}")
  end
end