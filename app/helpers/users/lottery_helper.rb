module Users::LotteryHelper
  def progress(item)
    total_progress = ((item.bets.batch_active_bets(item.batch_count).count.to_f/item.minimum_bets.to_f) * 100)
    [total_progress, 100].min.to_i
  end

end