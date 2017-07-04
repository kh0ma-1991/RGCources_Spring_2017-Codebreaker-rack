require 'erb'
require 'base64'
require 'yaml'
require 'codebreaker'
require 'json'
require_relative 'helpers/session_helper'
require_relative 'models/session'
require_relative 'helpers/score_helper'
require_relative 'models/score'
require_relative 'router'

module CodebreakerRackApp
  class Controller
    def initialize(env = nil)
      @request = Rack::Request.new(env)
      @router = Router.new(@request)
    end

    def response
      case @request.path
        when '/'            then @router.index
        when '/attempts'    then @router.attempt
        when '/playing'     then @router.playing
        when '/check'       then @router.check
        when '/hint'        then @router.hint
        when '/play_again'  then @router.play_again
        when '/score'       then @router.score
        else                     @router.not_found
      end
    end

    def call(env)
      Controller.new(env).response.finish
    end
  end
end