class CreateBanners < ActiveRecord::Migration[6.1]
  def change
    create_table :banners do |t|
      t.string :preview
      t.integer :status
      t.datetime :offline_at
      t.datetime :online_at
      t.datetime :deleted_at
      t.timestamps
    end
  end
end
