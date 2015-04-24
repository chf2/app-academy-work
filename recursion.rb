def range(start_num, end_num)
  array = []
  if end_num - start_num <= 1
    return array += []
  else
    array += range(start_num, end_num - 1) + ([end_num - 1])
  end

  array
end

def iterative_sum(array)
  sum = 0
  array.length.times do |i|
    sum += array[i]
  end

  sum
end

def recursive_sum(array)
  return array[0] if array.length <= 1

  dup_ary = array.dup
  last_element = dup_ary.pop
  recursive_sum(dup_ary) + last_element
end

def exp_recursion_1(base, power)
  return 1 if power == 0

  base * exp_recursion_1(base, power - 1)
end

def exp_recursion_2(base, power)
  return 1 if power == 0

  if power.even?
    exp_recursion_2(base, power/2)*exp_recursion_2(base, power/2)
  else
    base*exp_recursion_2(base, (power-1)/2)*exp_recursion_2(base, (power-1)/2)
  end
end

class Array
  def deep_dup
    dup_array = []
    self.each do |el|
      el.is_a?(Array) ? dup_array << el.deep_dup : dup_array << el
    end

    dup_array
  end
end

def iterative_fib(n)
  return [] if n <= 0
  return [1] if n == 1

  fib_arr = [1, 1]
  while fib_arr.size < n
    fib_arr << fib_arr[-1] + fib_arr[-2]
  end

  fib_arr
end

def recursive_fib(n)
  return [] if n <= 0
  return [1] if n == 1
  return [1, 1] if n == 2
  previous_array = recursive_fib(n-1)
  previous_array + [previous_array[-1] + previous_array[-2]]
end

def bsearch(array, target)
  if array.size == 1
    return 0 if array.include?(target)
    return nil
  end

  middle = array.size / 2
  case target <=> array[middle]
  when 1
    position = bsearch(array[(middle + 1)..-1], target)
    position += middle + 1 unless position.nil?
  when -1
    position = bsearch(array[0...middle], target)
  when 0
    position = middle
  end

  position
end

def make_change(amount, coins = [25, 10, 5, 1])
  best_solution = []
  # Base cases
  return best_solution if amount == 0

  # Iterations
  coins.each do |coin|
    if coin <= amount
      option = [coin] + make_change(amount - coin, coins)
      if best_solution.empty? || option.size < best_solution.size
        best_solution = option
      end
    end
  end

  best_solution
end

def merge_sort(arr)
  return [] if arr.length == 0
  return arr if arr.length == 1

  middle = arr.length / 2
  left = arr[0...middle]
  right = arr[middle..-1]
  merge(merge_sort(left), merge_sort(right))
end

def merge(left, right)
  merged_array = []
  until left.empty? || right.empty?
    if left.first <= right.first
      merged_array << left.shift
    else
      merged_array << right.shift
    end
  end

  merged_array + right + left
end

def subsets(array)
  subsets = []
  return [[]] if array.empty?

  last_element = [array.pop]
  subsets(array).each do |sub_ary|
    subsets << sub_ary
    subsets << (sub_ary + last_element)
  end

  subsets
end
