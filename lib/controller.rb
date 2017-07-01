require 'erb'
require 'base64'
require 'yaml'
require 'codebreaker'
require 'json'

module CodebreakerRackApp
  class Controller
    def initialize(env = nil)
      @request = Rack::Request.new(env)
    end

    def response
      case @request.path
        when '/' then Rack::Response.new(render('index.erb'))
        when '/attempts'
          Rack::Response.new(render('attempts.erb'))
        when '/playing'
          response = Rack::Response.new(render('playing.erb'))
          response.set_header("attempts", attempts) if @request.post?
          response.set_header("hints", hints) if @request.post?
          game = Codebreaker::Game.new
          game.attempts = attempts.to_i
          game.hints = hints.to_i
          game.start
          response.set_cookie('game', Base64.encode64(YAML.dump(game)))
          response
        when '/check'
          response = Rack::Response.new
          game = YAML.load(Base64.decode64(@request.cookies["game"]))
          guess = @request.params['guess']
          answer = game.check_code(guess)
          attempts = game.attempts
          response.set_cookie('game', Base64.encode64(YAML.dump(game)))
          response.write(JSON.generate({answer: answer, attempts: attempts}))
          response
        when '/hint'
          response = Rack::Response.new
          game = YAML.load(Base64.decode64(@request.cookies["game"]))
          hint = game.hint
          hints = game.hints
          response.set_cookie('game', Base64.encode64(YAML.dump(game)))
          response.write(JSON.generate({hint: hint, hints: hints}))
          response
        when '/play_again'
          Rack::Response.new(render('play_again.erb'))
        else Rack::Response.new('Not Found', 404)
      end
    end

    def render(template)
      path = File.expand_path("../../views/#{template}", __FILE__)
      ERB.new(File.read(path)).result(binding)
    end

    def call(env)
      Controller.new(env).response.finish
    end

    def attempts
      @request.params['attempts'] || 'Nothing'
    end

    def hints
      @request.params['hints']    || 'Nothing'
    end
  end
end