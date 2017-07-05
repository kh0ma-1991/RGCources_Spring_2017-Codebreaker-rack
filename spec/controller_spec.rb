require 'spec_helper'
require 'rack/test'

module CodebreakerRackApp
  class ControllerSpec
    OUTER_APP = Rack::Builder.parse_file('config.ru').first

    RSpec.describe Controller do
      include Rack::Test::Methods

      def app
        OUTER_APP
      end

      describe '200' do
        it '/' do
          get '/'
          expect(last_response.status).to eq(200)
        end
        it '/attempts' do
          get '/attempts'
          expect(last_response.status).to eq(200)
        end
        it '/playing' do
          get '/playing'
          expect(last_response.status).to eq(200)
        end
        it '/check' do
          get '/playing'
          get '/check', guess: '1234'
          expect(last_response.status).to eq(200)
        end
        it '/hint' do
          get '/playing'
          get '/hint'
          expect(last_response.status).to eq(200)
        end
        it '/play_again' do
          get '/play_again'
          expect(last_response.status).to eq(200)
        end
        it '/score' do
          get '/score'
          expect(last_response.status).to eq(200)
        end
      end

      describe '404' do
        it '/smth' do
          get '/smth'
          expect(last_response.status).to eq(404)
        end
      end
    end
  end
end
