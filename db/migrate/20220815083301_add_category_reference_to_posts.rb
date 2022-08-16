class AddCategoryReferenceToPosts < ActiveRecord::Migration[6.1]
  def change
    add_reference :items, :category
  end
end
