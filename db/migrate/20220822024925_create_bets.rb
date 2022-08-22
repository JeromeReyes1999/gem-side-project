class CreateBets < ActiveRecord::Migration[6.1]
  def change
    create_table :bets do |t|
      t.integer :batch_count
      t.integer :coins
      t.string :state
      t.string :serial_number
      t.belongs_to :item
      t.belongs_to :user
      t.timestamps
    end
  end
end
