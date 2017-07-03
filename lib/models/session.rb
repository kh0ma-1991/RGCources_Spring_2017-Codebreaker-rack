module CodebreakerRackApp
  class Session
    attr_accessor :session_id, :game

    def initialize (session_id, game)
      @session_id = session_id
      @game = game
    end
  end
end