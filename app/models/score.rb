class Score < ActiveRecord::Base
  attr_accessible :id, :username, :uuid, :correct, :wrong

  def self.get_score(uuid, username)
    score = Score.where(:username => username, :uuid => uuid)

    if score.empty?
      score = Score.new
      score.username = username
      score.uuid = uuid
      score.correct = 0
      score.wrong = 0
      score.save()
      return score
    end

    return score[0]
  end

  def total
    return (self.correct + self.wrong)
  end

  def score
    current_score = self.correct - self.wrong
    if current_score > 0
      return current_score
    else
      return 0
    end
  end
end
