class CreateWinners < ActiveRecord::Migration[6.1]
  def change
    create_table :winners do |t|
      t.belongs_to :item
      t.belongs_to :user
      t.belongs_to :address
      t.belongs_to :admin
      t.integer :batch_count
      t.string :state
      t.decimal :price
      t.datetime :paid_at
      t.string :picture
      t.string :comment
      t.timestamps
    end
  end
end
