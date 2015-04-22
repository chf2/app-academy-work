class RPN

  attr_reader :stack

  ACCEPTABLE_OPERATORS = %w[+ - * / calculate]

  def self.sanitize(new_char)
    self.is_operator?(new_char) ? new_char : Integer(new_char)
  end

  def self.is_operator?(input)
    ACCEPTABLE_OPERATORS.include?(input)
  end

  def initialize(full_stack = [])
    @stack = full_stack
  end

  def run
    if stack.empty?
      puts "Enter stuff to calculate via Revers Polish notation!"
      while stack[-1] != "calculate"
        display
        get_input
      end
      stack.pop
    end

    result = rpn_eval
    puts "The answer is #{result}"
  end

  def display
    puts "Current stack:"
    puts "\n#{stack}"
  end

  def get_input
    puts "Input characters one at a time."
    puts "When ready to calculate, type 'calculate'"
    new_char = gets.strip
    new_char = RPN.sanitize(new_char)
    stack << new_char
  end

  def rpn_eval
    new_stack = []

    stack.each_with_index do |el, idx|
      if RPN.is_operator?(el)
        second = new_stack.pop
        first = new_stack.pop
        operator = el.to_sym
        intermediary_result = operation(second, first, operator)
        new_stack.push(intermediary_result)
      else
        new_stack << el
      end
    end

    new_stack[0]
  end

  def operation(second, first, operator)
    # eval("#{first} #{operator} #{second}")
    first.send(operator, second)
  end

end

if __FILE__ == $PROGRAM_NAME
  if !ARGV.empty?
    file_input = File.read(ARGV[0])
    input_stack = file_input.split(" ")
    sanitized_stack = input_stack.map { |el| RPN.sanitize(el) }
  else
    sanitized_stack = []
  end

  rpn = RPN.new(sanitized_stack)
  rpn.run
end
