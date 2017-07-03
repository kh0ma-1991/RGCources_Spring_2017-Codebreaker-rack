module CodebreakerRackApp
  class Score
    attr_accessor name, score, date
    def initialize (name, session_id)
      @name = name
      @date = Time.now
      @score = ScoreHelper.get_score (session_id)
    end
  end
end