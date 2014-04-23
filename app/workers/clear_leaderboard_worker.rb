class ClearLeaderboardWorker
  @queue = 'low'
  def self.perform
    Leaderboard.clear
  end
end
