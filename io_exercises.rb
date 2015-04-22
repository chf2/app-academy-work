class NumberGuessGame
  #computer chooses number 1-100 randomly
  #get guess from user
  #evaluate guess, return high or low
  #keep track of guesses
  attr_accessor :user_guess, :guess_counter, :secret_number

  def initialize
    @guess_counter = 0
  end

  def play
    greet
    @secret_number = (1..100).to_a.sample

    while !guessed?
      get_guess
      check_guess
    end
  end

  def get_guess
    print "What's your guess? >>"
    self.user_guess = Integer(gets)
    while !valid_input?(user_guess)
      puts "Please input a number between 1-100:"
      self.user_guess = Integer(gets)
    end
    self.guess_counter += 1
  end

  def valid_input?(guess)
    (1..100).include?(guess)
  end

  def greet
    puts "Welcome to the guessing game."
    puts "Try and guess my number between 1 and 100."
  end

  def check_guess
    if user_guess < @secret_number
      puts "Too low"
    elsif user_guess > @secret_number
      puts "Too high"
    else
      puts "You win! It took #{guess_counter} guesses."
    end
  end

  def guessed?
    user_guess == @secret_number
  end

end

def file_line_shuffle
  puts "Please enter filename to shuffle"
  filename = gets.strip
  base_name = File.basename("#{filename}", ".*")
  extension = File.extname("#{filename}")

  lines = File.readlines("#{filename}")
  lines.shuffle!

  File.open("#{base_name}-shuffled#{extension}", "w") do |f|
    lines.each do |line|
      f.puts line
    end
  end
end
