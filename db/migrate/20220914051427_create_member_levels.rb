class CreateMemberLevels < ActiveRecord::Migration[6.1]
  def change
    create_table :member_levels do |t|
      t.string :level
      t.integer :required_members
      t.integer :coins
      t.timestamps
    end
  end
end
