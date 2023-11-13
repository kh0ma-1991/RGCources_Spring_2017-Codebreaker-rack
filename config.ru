require_relative 'lib/controller'
require 'rack'

use Rack::Reloader
use Rack::Static, urls: ['/css', '/js', '/icons', '/images'], root: 'static'
run CodebreakerRackApp::Controller.new
