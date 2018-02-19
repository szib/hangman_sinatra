require 'sinatra'
require_relative 'lib/hangman'

if development?
  require 'dotenv'
  require 'sinatra/reloader'
end

configure do
  enable :sessions
end

get '/' do
  "Hello, Hangman..."
end
