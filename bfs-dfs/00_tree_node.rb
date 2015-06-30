class PolyTreeNode
  attr_reader :value, :children, :parent

  def initialize(value)
    @value = value
    @parent = nil
    @children = []
  end

  def parent=(parent_node)
    @parent.children.delete(self) unless @parent.nil?
    @parent = parent_node
    parent_node.children << self unless parent_node.nil?
  end

  def add_child(child_node)
    child_node.parent=(self)
  end

  def remove_child(child_node)
    raise "Not a child" unless @children.include?(child_node)
    child_node.parent=(nil)
  end

  def dfs(target_value)
    return self if @value == target_value
    @children.each do |child|
      found_child = child.dfs(target_value)
      return found_child unless found_child.nil?
    end

    nil
  end

  def bfs(target_value)
    queue = [self]
    until queue.empty?
      shifted_object = queue.shift
      if target_value == shifted_object.value
        return shifted_object
      else
        shifted_object.children.each { |child| queue.push(child) }
      end
    end

    nil
  end

  def trace_path_back
    path = [@value]
    parent = @parent
    until parent.nil?
      path << parent.value
      parent = parent.parent
    end

    path
  end

end
