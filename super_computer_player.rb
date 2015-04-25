require_relative 'tic_tac_toe_node'

class SuperComputerPlayer < ComputerPlayer
  def move(game, mark)
    node = TicTacToeNode.new(game.board, mark)
    move = nil
    node.children.each do |child|
      move = child.prev_move_pos if child.winning_node?(mark)
      move = child.prev_move_pos if !child.losing_node?(mark) && move.nil?
    end

    raise "Only losing moves!" if move.nil?
    move
  end
end

if __FILE__ == $PROGRAM_NAME
  puts "Play the brilliant computer!"
  hp = HumanPlayer.new("Jeff")
  cp = SuperComputerPlayer.new

  TicTacToe.new(hp, cp).run
end
