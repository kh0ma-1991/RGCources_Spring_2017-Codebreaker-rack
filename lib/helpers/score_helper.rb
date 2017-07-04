module CodebreakerRackApp
  class ScoreHelper
    @@scores_path = File.expand_path("../../../data/scores.yml", __FILE__)

    def initialize
      @sessions_helper = SessionHelper.new
    end

    def get_score (session_id)
      session = @sessions_helper.session(session_id)
      used_attempts = session.attempts_counter
      used_hints = session.hint_counter
      score_amount = 1000
      score_amount -= (used_attempts - 3) * 55 if used_attempts >= 3
      score_amount -= used_hints * 113 + 1 if used_hints > 0
      score_amount
    end

    def save (score)
      scores = all || []
      scores.push score
      File.write(@@scores_path,YAML.dump(scores))
    end

    def all
      YAML.load(File.read(@@scores_path)) if File.readable? @@scores_path
    end
  end
end
