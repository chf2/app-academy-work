class Code
  attr_reader :code

  COLORS = %w( R G B Y O P )

  def initialize(code)
    @code = code
  end

  def self.random
    secret_code = []
    4.times { secret_code << COLORS.sample }

    Code.new(secret_code)
  end

  def self.parse(input)
    Code.new(input.upcase.split(''))
  end

  def valid_code?
    code.length == 4 && code.all? { |peg| COLORS.include?(peg) }
  end

  def exact_matches(player_code)
    matches = 0
    4.times { |i| matches += 1 if player_code.code[i] == code[i] }

    matches
  end

  def near_matches(player_code)
    matches = Hash.new { 0 }
    player_code.code.each do |peg|
      matches[peg] += 1 if code.include?(peg) && matches[peg] < code.count(peg)
    end

    matches.values.inject(0, :+) - exact_matches(player_code)
  end
end

class Game
  def initialize
    @secret_code = Code.random
    @turns = 0
    @guess = nil
  end

  def play
    until over?
      @turns += 1
      puts "Turn #{@turns}"
      @guess = get_input
      display_matches(get_matches(@guess))
    end

    puts "Computer code was: #{@secret_code.code.inspect}"
  end

  def over?
    if @guess && (get_matches(@guess)[0] == 4)
      puts "You win! It took #{@turns} turn(s)."
      true
    elsif @turns == 10
      puts "You lose!"
      true
    else
      false
    end
  end

  def get_input
    puts "Enter guess as string."
    parsed_input = Code.parse(gets.chomp)
    while !parsed_input.valid_code?
      puts "Invalid, enter new guess."
      parsed_input = Code.parse(gets.chomp)
    end

    parsed_input
  end

  def get_matches(guess)
    [@secret_code.exact_matches(guess), @secret_code.near_matches(guess)]
  end

  def display_matches(matches)
    puts "Exact matches: #{matches[0]}"
    puts "Near matches: #{matches[1]}"
  end
end
