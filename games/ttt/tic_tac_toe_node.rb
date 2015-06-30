require_relative 'tic_tac_toe'

class TicTacToeNode

  attr_reader :board, :next_mover_mark, :prev_move_pos

  def initialize(board, next_mover_mark, prev_move_pos = nil)
    @board = board
    @next_mover_mark = next_mover_mark
    @prev_move_pos = prev_move_pos
  end

  def losing_node?(evaluator)
    other_mark = (evaluator == :x ? :o : :x)
    return (@board.winner == other_mark) if @board.over?
    if evaluator == @next_mover_mark
      children.all? { |child| child.losing_node?(evaluator) }
    else
      children.any? { |child| child.losing_node?(evaluator) }
    end
  end

  def winning_node?(evaluator)
    other_mark = (evaluator == :x ? :o : :x)
    return (@board.winner == evaluator) if @board.over?

    if evaluator == @next_mover_mark
      children.any? {|child| child.winning_node?(evaluator) }
    else
      children.all? {|child| child.winning_node?(evaluator) }
    end
  end


  # This method generates an array of all moves that can be made after
  # the current move.
  def children
    empty_positions = []
    children = []
    @board.rows.count.times do |row|
      @board.rows.count.times do |column|
        empty_positions << [row,column] if @board.empty?([row,column])
      end
    end

    empty_positions.each do |position|
      new_board = @board.dup
      new_board[position] = @next_mover_mark
      new_mark = (@next_mover_mark == :x ? :o : :x)
      node = TicTacToeNode.new(new_board, new_mark, position)
      children << node
    end

    children
  end


end
