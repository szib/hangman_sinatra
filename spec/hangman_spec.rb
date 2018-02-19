require './lib/hangman.rb'

describe 'Hangman' do
  def guess_all_letters
    ('a'..'z').each do |x|
      @hangman.guess(x)
    end
  end

  before(:example) do
    @hangman = Hangman.new
  end

  it 'should have a random word with correct length' do
    expect(@hangman.word.length >= 5 && @hangman.word.length <= 12).to eq(true)
  end

  it 'should be able to test for lose' do
    expect(@hangman.has_more_attempt?).to eq(true)
    guess_all_letters
    expect(@hangman.has_more_attempt?).to eq(false)
  end

  it 'should be able to test for win' do
    expect(@hangman.not_win?).to eq(true)
    guess_all_letters
    expect(@hangman.not_win?).to eq(false)
  end

  it 'should give an error for invalig JSON' do
    content = "{ sdf }"
    File.open('saved_game.json', 'w') do |f|
      f.write(content)
    end
    res = @hangman.load
    expect(res).to eq(1)
  end

  it 'should save and load state' do
    @hangman.save
    another_hangman = Hangman.new
    res = another_hangman.load
    expect(res).to eq(0)
    expect(@hangman.to_s == another_hangman.to_s).to eq(true)
  end

  it 'should give an error at loading' do
    File.delete('saved_game.json')
    res = @hangman.load
    expect(res).to eq(1)
    @hangman.save
  end


end
