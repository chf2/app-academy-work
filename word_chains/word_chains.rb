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
    source.downcase!
    target.downcase!
    @current_words = [source]
    @all_seen_words = {source => nil}
    @target_found = false
    until @current_words.empty? || @target_found
      new_current_words = explore_current_words(target)
      @current_words = new_current_words
    end

    p build_path(target)
  end

  def explore_current_words(target)
    new_current_words = []
    @current_words.each do |current_word|
      adjacent_words(current_word).each do |adjacent_word|
        next if @all_seen_words.include?(adjacent_word) || @target_found
        new_current_words << adjacent_word
        @all_seen_words[adjacent_word] = current_word
        if adjacent_word == target
          @target_found = true
          break
        end
      end
    end

    new_current_words
  end

  def build_path(target)
    search = target
    path = [target]
    until @all_seen_words[search].nil?
      path << @all_seen_words[search]
      search = @all_seen_words[search]
    end

    path
  end
end
