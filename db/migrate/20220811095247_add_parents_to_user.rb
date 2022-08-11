class AddParentsToUser < ActiveRecord::Migration[6.1]
  def change
    add_reference :users, :parent, index: true
  end
end
