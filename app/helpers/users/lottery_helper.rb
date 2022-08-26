module Users::LotteryHelper
  def progress(item)
    ((item.bets.where(batch_count: item.batch_count).count.to_f/item.minimum_bets.to_f) * 100).to_i
  end

end