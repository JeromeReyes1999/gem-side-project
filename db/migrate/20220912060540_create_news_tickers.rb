class CreateNewsTickers < ActiveRecord::Migration[6.1]
  def change
    create_table :news_tickers do |t|
      t.string :content
      t.integer :status
      t.belongs_to :admin
      t.timestamps
    end
  end
end
