def factors(num)
  factors = [1, num]
  i = 2

  while i <=  (num / 2)
    factors << i if num % i == 0
    i += 1
  end

  factors.sort.uniq
end

def bubble_sort(mix_aray)
  sorted = false

  while !sorted
    sorted = true
    mix_aray.each_index do |indx|
      next if !mix_aray[indx + 1]
      if mix_aray[indx] > mix_aray[indx + 1]
        mix_aray[indx] , mix_aray[indx + 1] = mix_aray[indx + 1] , mix_aray[indx]
        sorted = false
      end
    end
  end

  mix_aray
end

def substrings(str)
  output = []
  i = 0
  while i < str.length - 1
    j = i
    while j < str.length
      substr = str[i..j]
      output << substr
      j += 1
    end

    i += 1
  end

  output << str[-1]
end

def subwords(word)
  dictionary = []

  File.foreach("dictionary.txt") do |line|
    dictionary << line.chomp
  end

  substrings(word).select { |el| dictionary.include?(el) }
end
