module CodebreakerRackApp
  class Router
    def initialize(request)
      @request = request
      @session_helper = SessionHelper.new
      @score_helper = ScoreHelper.new
    end

    def index
      Rack::Response.new(render('index.erb'))
    end

    def attempt
      Rack::Response.new(render('attempts.erb'))
    end

    def playing
      response = Rack::Response.new(render('playing.erb'))
      response.set_header("attempts", attempts) if @request.post?
      response.set_header("hints", hints) if @request.post?
      game = Codebreaker::Game.new
      game.attempts = attempts.to_i
      game.hints = hints.to_i
      game.start
      session_id = @session_helper.next_id
      @session_helper.save(Session.new(session_id, game))
      response.set_cookie('session_id', Base64.encode64(session_id.to_s))
      response
    end

    def check
      response = Rack::Response.new
      session_id = Base64.decode64(@request.cookies['session_id']).to_i
      session = @session_helper.session(session_id)
      game = session.game
      guess = @request.params['guess']
      answer = game.check_code(guess)
      attempts = game.attempts
      @session_helper.save(session.get_attempt)
      response.set_cookie('session_id', Base64.encode64(session_id.to_s))
      response.write(JSON.generate({answer: answer, attempts: attempts}))
      response
    end

    def hint
      response = Rack::Response.new
      session_id = Base64.decode64(@request.cookies['session_id']).to_i
      session = @session_helper.session(session_id)
      game = session.game
      hint = game.hint
      hints = game.hints
      @session_helper.save(session.get_hint)
      response.set_cookie('session_id', Base64.encode64(session_id.to_s))
      response.write(JSON.generate({hint: hint, hints: hints}))
      response
    end

    def score
      response = Rack::Response.new
      if(@request.post?)
        name = @request.params['name']
        session_id = Base64.decode64(@request.cookies['session_id']).to_i
        score = Score.new(name, session_id)
        @score_helper.save(score)
      else
        response.write(JSON.generate(@score_helper.all))
      end
      response
    end

    def play_again
      Rack::Response.new(render('play_again.erb'))
    end

    def not_found
      Rack::Response.new('Not Found', 404)
    end

    private

    def render(template)
      path = File.expand_path("../../views/#{template}", __FILE__)
      ERB.new(File.read(path)).result(binding)
    end

    def attempts
      @request.params['attempts'] || 'Nothing'
    end

    def hints
      @request.params['hints']    || 'Nothing'
    end
  end
end