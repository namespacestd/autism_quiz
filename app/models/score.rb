class Score < ActiveRecord::Base
  attr_accessible :id, :username, :uuid, :score

  def self.get_score(uuid, username)
    score = Score.where(:username => username, :uuid => uuid)

    if score.empty?
      score = Score.new
      score.username = username
      score.uuid = uuid
      score.score = 0
      score.save()
      return score
    end

    return score[0]
  end
end
