require 'sinatra'
require_relative 'lib/hangman'

require 'sinatra/reloader' if development?

configure do
  enable :sessions
end

# def end(result, word)
#   redirect to("/end/#{result}/#{word}")
# end

get '/new_game' do
  session[:hangman] = Hangman.new
  redirect to('/')
end

get '/end/:result/:word' do
  erb :end, locals: { result: params['result'], word: params['word'] }
end

get '/' do
  msg = nil
  session[:hangman] = Hangman.new if session[:hangman].nil?
  word = session[:hangman].word.join('')

  # redirect to("/end/lost/#{word}") unless session[:hangman].has_more_attempt?
  # redirect to("/end/won/#{word}") unless session[:hangman].not_win?

  unless session[:hangman].game_over?
    session[:hangman].guess(params['guess'])
    # if params['guess'] =~ /^([a-z]|[A-Z])$/
  end

  redirect to("/end/lost/#{word}") unless session[:hangman].has_more_attempt?
  redirect to("/end/won/#{word}") unless session[:hangman].not_win?

  word_mask = session[:hangman].word_mask.join(' ')
  turns_left = session[:hangman].remaining_attempts.to_s
  guessed_letters = session[:hangman].guessed_letters.join(', ')

  # puts session.inspect
  erb :index, locals: { word_mask: word_mask, turns_left: turns_left, guessed_letters: guessed_letters }
end
