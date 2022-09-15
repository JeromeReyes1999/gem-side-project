class AddSortToBanners < ActiveRecord::Migration[6.1]
  def change
    add_column :banners, :sort, :integer
  end
end
