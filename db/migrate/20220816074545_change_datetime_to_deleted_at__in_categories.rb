class ChangeDatetimeToDeletedAtInCategories < ActiveRecord::Migration[6.1]
  def change
    add_column :categories, :deleted_at, :datetime
    remove_column  :categories, :datetime
  end
end
