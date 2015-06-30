# game has a board, two players,

# board has grid of cells
# board has a

# players make moves,
#players have either x or o

class Board
  attr_reader :grid

  def initialize
    @grid = [
      [1,2,3],
      [4,5,6],
      [7,8,9]
    ]
    @winner = nil

  end

  def cell_value(input)
    coords = map_input_to_grid(input)
    x = coords[1]
    y = coords[0]
    grid[y][x]
  end

  def empty?(input)
    cell_value(input).is_a? Fixnum
  end

  def map_input_to_grid(input)
    map_hash = {
      '1' => [0,0],
      '2' => [0,1],
      '3' => [0,2],
      '4' => [1,0],
      '5' => [1,1],
      '6' => [1,2],
      '7' => [2,0],
      '8' => [2,1],
      '9' => [2,2]
    }

    map_hash[input]
  end

  def display
    p grid[0]
    p grid[1]
    p grid[2]
  end

  def place_mark(input, mark)
    if empty?(input)
      y, x = map_input_to_grid(input)
      grid[y][x] = mark
      return true
    end

    false
  end

  def won?(marker)
    test_case = Array.new(3){marker}
    grid.each do |row|
      return true if row == test_case
    end

    transposed = grid.transpose

    transposed.each do |row|
      return true if row == test_case
    end

    diag1 = [cell_value('1'), cell_value('5'), cell_value('9')]
    diag2 = [cell_value('7'), cell_value('5'), cell_value('3')]

    return true if diag1 == test_case || diag2 == test_case
    false
  end

end

class Game
  attr_reader :player1, :player2

  def initialize(player1, player2)
    @player1 = player1
    @player2 = player2
  end

  def play

  end
end

class Player

  attr_reader :marker

  def initialize(marker)
    @marker = marker
  end

end

class HumanPlayer < Player

  def get_move
    print "Please enter your move >> "
    move = gets.strip
  end
end
