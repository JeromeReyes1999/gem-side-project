class ChangeBatchCountInItems < ActiveRecord::Migration[6.1]
  def change
    change_column :items, :batch_count, :integer, default: 0
  end
end
