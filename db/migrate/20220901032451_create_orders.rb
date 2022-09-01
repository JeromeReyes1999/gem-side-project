class CreateOrders < ActiveRecord::Migration[6.1]
  def change
    create_table :orders do |t|
      t.belongs_to :user
      t.belongs_to :offer
      t.string :serial_number
      t.string :state
      t.string :remarks
      t.decimal :amount, default: 0
      t.integer :coin, default: 0
      t.integer :genre
      t.timestamps
    end
  end
end
