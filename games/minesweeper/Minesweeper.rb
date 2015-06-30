require 'yaml'

class Tile
  attr_accessor :is_bomb

  def initialize(board, position)
    @board = board
    @position = position
    @is_bomb, @flag, @revealed = false, false, false
  end

  def flag
    @flag = !@flag
  end

  def flagged?
    @flag
  end

  def is_bomb?
    @is_bomb
  end

  def neighbors
    if @neighbors
      @neighbors
    else
      neighbors = []
      adjustments = [[-1, -1], [-1, 0], [-1, 1], [0, -1], [0, 1], [1, -1], [1, 0], [1, 1]]
      adjustments.each do |dx, dy|
        neighbors << [@position[0] + dx, @position[1] + dy]
      end

      @neighbors = neighbors.select { |x, y| x.between?(0, 8) && y.between?(0, 8) }
    end
  end

  def neighbor_bomb_count
    bomb_count = 0
    neighbors.each do |pos|
      bomb_count += 1 if @board.get_tile(pos).is_bomb?
    end
    bomb_count
  end

  def render
    if flagged?
      "F"
    elsif revealed?
      neighbor_bomb_count > 0 ? neighbor_bomb_count.to_s : "_"
    else
      "*"
    end
  end

  def reveal
    self.revealed = true
    if neighbor_bomb_count == 0
      tiles = neighbors.map{ |position| @board.get_tile(position) }
      tiles.each do |tile|
        tile.reveal unless tile.flagged? || tile.revealed?
      end
    end
    nil
  end

  def revealed?
    @revealed
  end
end

class Board
  attr_reader :grid_size, :num_bombs, :grid

  def initialize(grid_size = 9, num_bombs = 10)
    @grid_size = grid_size
    @num_bombs = num_bombs
    @flag_count = 0
    @grid = Array.new(@grid_size) { Array.new(@grid_size) }
    make_grid
  end

  def display
    puts "Number of bombs: #{@num_bombs}"
    puts "Flagged cells: #{@flag_count}"
    print "   "
    @grid.size.times do |col_counter|
      print "  #{col_counter}  "
    end
    puts
    @grid.each_with_index do |row, idx|
      print "#{idx}  "
      p row.map(&:render)
    end

    nil
  end

  def get_tile(pos)
    row, col = pos
    @grid[row][col]
  end

  def make_grid
    @grid_size.times do |row|
      @grid_size.times do |col|
        @grid[row][col] = Tile.new(self, [row, col])
      end
    end
    place_bombs

    nil
  end

  def place_bombs
    bombs_left = @num_bombs
    while bombs_left > 0
      row = (0..8).to_a.sample
      col = (0..8).to_a.sample
      unless @grid[row][col].is_bomb?
        @grid[row][col].is_bomb = true
        bombs_left -= 1
      end
    end
  end

  def won?
    flag_count == num_bombs && grid.flatten.all? { |tile| tile.flagged? || tile.revealed? }
  end

end

class Game

  def initialize
    @board = Board.new
    @start_time = Time.now
  end

  def display_score
    score = Time.now - @start_time
    puts "You won! It took you #{score/60} minutes, #{score%60} seconds."
  end

  def get_input
    puts "Choose square to reveal or flag—e.g. r00."
    input = gets.chomp.split('')

    save if input.join.downcase == "save"
    load_game if input.join.downcase == "load"

    choice = input.shift.downcase
    position = input.map(&:to_i)
    until valid_input?(choice, position)
      input = gets.chomp.split('')
      choice = input.shift.downcase
      position = input.map(&:to_i)
    end

    {choice: choice, position: position}
  end

  def load_game
    YAML.load_file('saved_game.yml').play
  end

  def over?
    @board.won?
  end

  def play
    until over?
      @board.display
      input = get_input
      tile = @board.get_tile(input[:position])
      if input[:choice] == "f"
        tile.flagged? ? @board.flag_count -= 1 : @board.flag_count += 1
        tile.flag
      elsif tile.is_bomb?
        puts "You lost!"
        return
      else
        tile.reveal
      end
    end

    display_score
  end

  def save
    puts "Game saved!"
    File.open("saved_game.yml", "w") do |f|
      f.puts self.to_yaml
    end
  end

  def valid_input?(choice, position)
    x, y = position
    if !['f', 'r'].include?(choice)
      puts "Please choose flag: f or reveal: r."
    elsif !x.between?(0,8) || !y.between?(0,8)
      puts "That is not a valid entry. Please try again."
    elsif @board.get_tile(position).revealed?
      puts "That tile is already revealed. Please try again."
    elsif @board.get_tile(position).flagged? && choice == 'r'
      puts "Can't reveal a flagged tile. Please try again"
    else
      return true
    end

    return false
  end
end
