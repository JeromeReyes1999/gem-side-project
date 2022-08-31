class CreateOffers < ActiveRecord::Migration[6.1]
  def change
    create_table :offers do |t|
      t.string :image
      t.string :name
      t.integer :genre
      t.integer :status
      t.decimal :amount, default: 0
      t.integer :coins, default: 0
      t.timestamps
    end
  end
end
