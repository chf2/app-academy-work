class WordChainer
  def initialize(dictionary_file_name = './dictionary.txt')
    @dictionary = File.readlines(dictionary_file_name).map(&:chomp)
  end

  def adjacent_words(word)
    word.downcase!
    @dictionary.select do |d_word|
      d_word.length == word.length && adjacent?(word, d_word)
    end
  end

  def adjacent?(word1, word2)
    counter = 0

    word1.length.times do |i|
      counter += 1 if word1[i] != word2[i]
    end

    counter == 1
  end

end
