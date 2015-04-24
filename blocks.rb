class Array
  def my_each(&prc)
    self.length.times do |idx|
      prc.call(self[idx])
    end

    self
  end

  def my_map(&prc)
    mapped_array = []
    self.my_each do |el|
      mapped_array << prc.call(el)
    end

    mapped_array
  end

  def my_select(&prc)
    selected_array = []
    self.my_each do |el|
      selected_array << el if prc.call(el)
    end

    selected_array
  end

  def my_inject
    memo = self.shift
    self.my_each do |el|
      memo = yield(memo, el)
    end

    memo
  end

  def my_sort!(&prc)
    sorted = false
    until sorted
    sorted = true
      self.length.times do |idx|
        next if idx == self.length
        if prc.call(self[idx], self[idx+1]) == 1
          self[idx], self[idx+1] = self[idx+1], self[idx]
          sorted = false
        end
      end
    end

    self
  end

end

def eval_block(*args)
  return yield(*args) if block_given?
  puts "NO BLOCK GIVEN"
end
