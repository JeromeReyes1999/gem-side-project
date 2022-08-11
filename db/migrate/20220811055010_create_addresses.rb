class CreateAddresses < ActiveRecord::Migration[6.1]
  def change
    create_table :addresses do |t|
      t.integer :genre
      t.string :name
      t.string :street_address
      t.string :phone_number
      t.string :remark
      t.boolean :is_default
      t.belongs_to :user
      t.belongs_to :region
      t.belongs_to :province
      t.belongs_to :city
      t.belongs_to :barangay
      t.timestamps
    end
  end
end
