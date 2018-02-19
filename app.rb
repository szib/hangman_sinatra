require 'sinatra'
require_relative 'lib/hangman'

if development?
  require 'dotenv'
  require 'sinatra/reloader'
end

configure do
  enable :sessions
end

get '/new_game' do
  session[:hangman] = Hangman.new
  redirect to('/')
end

get '/' do
  msg = nil
  if session[:hangman].nil?
    session[:hangman] = Hangman.new
  end

  msg = "No more attempt... You lost." unless session[:hangman].has_more_attempt?
  msg = "Grats. You won." unless session[:hangman].not_win?

  session[:hangman].guess(params['guess']) if params['guess'] =~ /^([a-z]|[A-Z])$/ && msg.nil?

  word = session[:hangman].word_mask.join(' ')
  turns_left = session[:hangman].remaining_attempts.to_s
  guessed_letters = session[:hangman].guessed_letters.join(', ')

  # puts session.inspect 
  erb :index, locals: { word: word, msg: msg, turns_left: turns_left, guessed_letters: guessed_letters }
end
