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
  erb :index, locals: { word: '_ _ _ _ _ _ D _ _', turns_left: 'chalkboard', incorrect_letters: 'a,b,c,s' }
end
