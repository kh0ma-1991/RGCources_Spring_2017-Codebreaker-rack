module CodebreakerRackApp
  class Session
    attr_accessor :session_id, :game, :hint_counter, :attempts_counter

    def initialize (session_id, game)
      @session_id = session_id
      @game = game
      @hint_counter = 0
      @attempts_counter = 0
    end

    def get_hint
      @hint_counter += 1
      self
    end

    def get_attempt
      @attempts_counter += 1
      self
    end
  end
end