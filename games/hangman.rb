
class Hangman
  def initialize(guessing_player, checking_player)
    @guessing_player = guessing_player
    @checking_player = checking_player
    @misses = 0
    @obscured_word, @missed_letters, @guessed_letters = [], [], []
    @guesser_is_winner = false
  end

  def play
    set_up_game
    until over?
      display
      @guessing_player.get_board(@obscured_word)
      guess = @guessing_player.guess

      if @guessed_letters.include?(guess)
        @misses += 1
      elsif @checking_player.correct_guess?(guess)
        positions = @checking_player.get_correct_positions(guess)
        update_obscured_word(positions, guess)
      else
        @misses += 1
        @missed_letters << guess
      end

      # if !@guessed_letters.include?(guess) && @checking_player.correct_guess?(guess)
      #   positions = @checking_player.get_correct_positions(guess)
      #   update_obscured_word(positions, guess)
      # else
      #   @misses += 1
      #   @missed_letters << guess unless @missed_letters.include?(guess)
      # end
      @guessed_letters << guess unless @guessed_letters.include?(guess)
    end

    [@guesser_is_winner, @misses]
  end

  def guess_is_valid?
  end

  def set_up_game
    @obscured_word = Array.new(@checking_player.pick_secret_word) { "_" }
    @guessing_player.receive_secret_length(@obscured_word.length)
  end

  def display
    puts "Obscured Word: #{@obscured_word.join(" ")}"
    puts "Missed Letters: #{@missed_letters.inspect}"
    puts "Number of misses: #{@misses}"
  end

  def update_obscured_word(positions, guess)
    positions.each { |pos| @obscured_word[pos] = guess}
  end

  def over?
    if !@obscured_word.include?("_")
      puts "Guessing player wins!"
      @guesser_is_winner = true
      true
    elsif @misses == 6
      puts "Checking player wins!"
      puts "The word was '#{@checking_player.secret_word.join}'"
      true
    else
      false
    end
  end
end

class HumanPlayer

  def initialize
    @word_length = 0
  end

  def secret_word
    puts "What was your word?"
    gets.chomp.split('')
  end

  def get_board
    #not needed
  end

  def guess
    "Please guess a letter:"
    guess = gets.chomp.downcase
    until ('a'..'z').include?(guess)
      puts "No, pick a letter:"
      guess = gets.chomp.downcase
    end

    guess
  end

  def get_correct_positions(guess)
    puts "Which letter position(s)? Ex: 1, 4, 5"
    positions = gets.chomp.split(", ")
    positions.map!(&:to_i)
    until positions.all? { |pos| pos.between?(1, @word_length) }
      puts "Invalid response, please try again:"
      positions = gets.chomp.split(", ")
      positions.map!(&:to_i)
    end
    positions.map { |pos| pos -= 1 }
  end

  def correct_guess?(guess)
    puts "Computer guessed '#{guess}', uncover a letter (y/n)?"
    response = gets.chomp.downcase
    until response == 'y' || response == 'n'
      puts "Please enter 'y' or 'n'"
      response = gets.chomp.downcase
    end

    response == 'y'
  end

  def receive_secret_length(word_length)
    puts "Length of secret word: #{word_length}"
  end

  def pick_secret_word
    puts "How long is your word?"
    @word_length = Integer(gets)
  end
end

class ComputerPlayer
  attr_reader :secret_word

  def initialize
    @secret_word, @dictionary, @guessed_letters = [], [], []
    @secret_length = 0
    @board_hash = {}
    load_dictionary
  end

  def get_board(obscured_word)
    obscured_word.each_with_index do |ltr, idx|
      @board_hash[idx] = ltr unless ltr == "_"
    end
  end

  def guess
    update_dictionary
    possibility_hash = construct_possibilities
    guess = get_best_guess(possibility_hash)

    @guessed_letters << guess
    guess
  end

  def pick_secret_word
    @secret_word = @dictionary.sample.split('')
    @secret_word.length
  end

  def get_correct_positions(guess)
    positions = []
    @secret_word.each_index do |idx|
      positions << idx if @secret_word[idx] == guess
    end

    positions
  end

  def correct_guess?(guess)
    @secret_word.include?(guess)
  end

  def receive_secret_length(word_length)
    @secret_length = word_length
    word_length.times { |pos| @board_hash[pos] = nil }
    @dictionary.select! { |word| word.length == word_length }
  end

  private

    def load_dictionary
      @dictionary = File.readlines("dictionary.txt").map(&:chomp)
    end

    def update_dictionary
      @dictionary.select! do |word|
        @board_hash.all? do |key, value|
          value.nil? || word[key] == value
        end
      end
    end

    def construct_possibilities
      possibility_hash = {}
      all_letters = @dictionary.join('')
      ('a'..'z').to_a.each do |ltr|
        possibility_hash[ltr] = all_letters.count(ltr)
      end

      possibility_hash
    end

    def get_best_guess(possibility_hash)
      possibility_array = possibility_hash.sort_by {|k,v| v}.reverse
      narrowed_array = possibility_array.select do |pair|
        !@guessed_letters.include?(pair[0])
      end

      narrowed_array[0][0]
    end
end

total_guesser_wins = 0
total_misses = 0

10000.times do
  guesser_wins, misses = Hangman.new(ComputerPlayer.new, ComputerPlayer.new).play
  total_guesser_wins += 1 if guesser_wins
  total_misses += misses
end

p ["#{(total_guesser_wins/10000.0).round(2)}%", (total_misses/10000.0).round(2)]
