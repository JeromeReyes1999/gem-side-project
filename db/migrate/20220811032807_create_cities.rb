class CreateCities < ActiveRecord::Migration[6.1]
  def change
    create_table :cities do |t|
      t.string :name
      t.string :code
      t.belongs_to :province
      t.timestamps
    end
  end
end
