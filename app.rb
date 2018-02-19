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
  msg = nil
  if session[:hangman].nil?
    session[:hangman] = Hangman.new
  end

  msg = "No more attempt... You lost." unless session[:hangman].has_more_attempt?
  msg = "Grats. You won." unless session[:hangman].not_win?

  puts session.inspect
  erb :index, locals: { word: '_ _ _ _ _ _ D _ _', msg: msg, turns_left: 'chalkboard', incorrect_letters: 'a,b,c,s' }
end
