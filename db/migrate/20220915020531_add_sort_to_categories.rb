class AddSortToCategories < ActiveRecord::Migration[6.1]
  def change
    add_column :categories, :sort, :integer
  end
end
