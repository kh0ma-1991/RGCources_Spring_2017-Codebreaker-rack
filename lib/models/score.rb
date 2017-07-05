module CodebreakerRackApp
  class Score
    attr_accessor :name, :score, :date
    def initialize(name, session_id)
      @name = name
      @date = Time.now
      @score = ScoreHelper.new.get_score (session_id)
    end

    def as_json(_options = {})
      { name: name, score: score, date: date }
    end

    def to_json(*options)
      as_json(*options).to_json(*options)
    end
  end
end
