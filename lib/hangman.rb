require 'json'

class Hangman
  attr_reader :remaining_attempts, :word

  def initialize(remaining_attempts = 12)
    @word = random_word.upcase.split('')
    @word_mask = Array.new(@word.length, '_')
    @remaining_attempts = remaining_attempts
    @guessed_letters = []
  end

  def display
    puts "\n\n\t#{@word_mask.join('')}"
    puts "\nGuessed letters: #{@guessed_letters.join(', ')}\n"
  end

  def not_win?
    @word != @word_mask
  end

  def has_more_attempt?
    @remaining_attempts > 0
  end

  def guess(letter)
    return unless letter =~ /^[a-zA-Z]$/ && @guessed_letters.none? { |x| x == letter.upcase }
    @guessed_letters.push(letter.upcase)
    if @word.none? { |x| x == letter.upcase }
      @remaining_attempts -= 1
    else
      @word.each.with_index do |x, i|
        @word_mask[i] = letter.upcase if x == letter.upcase
      end
    end
  end

  def to_s
    hash = {
      'word_mask' => @word_mask.join(''),
      'remaining_attempts' => @remaining_attempts,
      'word' => @word.join(''),
      'guessed_letters' => @guessed_letters
    }
    JSON.pretty_generate(hash)
  end

  def save
    File.open('saved_game.json', 'w') do |f|
      f.write(to_s)
    end
  end

  def load
    json = ''
    File.open('saved_game.json', 'r') do |f|
      json = f.read
    end
    hash = JSON.parse(json)
  rescue StandardError
    return 1
  else
    @word = hash['word'].split('')
    @word_mask = hash['word_mask'].split('')
    @remaining_attempts = hash['remaining_attempts']
    @guessed_letters = hash['guessed_letters']
    return 0
  end

  private

  def random_word
    words = ''
    File.open('5desk.txt', 'r') do |f|
      words = f.readlines.keep_if { |x| x.strip.length >= 5 && x.strip.length <= 12 }
    end
    words[rand(words.length)].strip
  end
end
