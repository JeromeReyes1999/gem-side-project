class AddSortToNewsTickers < ActiveRecord::Migration[6.1]
  def change
    add_column :news_tickers, :sort, :integer
  end
end
