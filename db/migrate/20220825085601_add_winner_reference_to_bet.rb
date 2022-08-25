class AddWinnerReferenceToBet < ActiveRecord::Migration[6.1]
  def change
    add_reference :winners, :bet
  end
end
