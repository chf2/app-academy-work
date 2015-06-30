require './00_tree_node.rb'

class KnightPathFinder
  def self.valid_moves(pos)
    adjs = [[-2, -1], [-2, 1], [-1, -2], [-1, 2], [1, -2], [1, 2], [2, -1], [2, 1]]
    moves = []

    adjs.each do |adj|
      moves << [pos[0] + adj[0], pos[1] + adj[1]]
    end

    moves.select{|move| move[0].between?(0, 7) && move[1].between?(0, 7)}
  end

  def initialize(start_pos = [0, 0])
    @start_pos = start_pos
    @visited_positions = [@start_pos]
    @root = build_move_trees
  end

  def build_move_tree
    root = PolyTreeNode.new(@start_pos)
    queue = [root]
    until queue.empty?
      current_node = queue.shift
      new_move_positions(current_node.value).each do |position|
        node = PolyTreeNode.new(position)
        node.parent=(current_node)
        queue << node
      end
    end

    root
  end

  def find_path(end_pos)
    end_pos_node = @root.bfs(end_pos)
    end_pos_node.trace_path_back.reverse
  end

  def new_move_positions(pos)
    valid_moves = self.class.valid_moves(pos)
    valid_moves.reject! { |move| @visited_positions.include?(move) }
    valid_moves.each do |move|
      @visited_positions << move
    end
  end


end
