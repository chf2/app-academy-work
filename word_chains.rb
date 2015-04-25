require 'Set'

class WordChainer
  def initialize(dictionary_file_name)
    @dictionary = Set.new(File.readlines(dictionary_file_name).map(&:chomp))
  end

  def adjacent_words(word)
    adjacent_words = []
    candidates = @dictionary.select{ |dword| dword.length == word.length }
    word.chars.each_index do |char_index|
      char = word[char_index]
      (('a'..'z').to_a - [char]).each do |new_letter|
        word[char_index] = new_letter
        adjacent_words << word.dup if candidates.include?(word)
      end
      word[char_index] = char
    end

    adjacent_words
  end

  def run(source, target)
    @current_words = [source]
    @all_seen_words = {source => nil}
    until @current_words.empty?
      new_current_words = explore_current_words
      p new_current_words
      @current_words = new_current_words
    end
  end

  def explore_current_words
    new_current_words = []
    @current_words.each do |current_word|
      adjacent_words(current_word).each do |adjacent_word|
        next if @all_seen_words.include?(adjacent_word)
        new_current_words << adjacent_word
        @all_seen_words[adjacent_word] = current_word
      end
    end

    new_current_words.each { |word| puts "#{word} --from: #{@all_seen_words[word]}"}
  end
end
