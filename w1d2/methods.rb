def rps(choice)
  possible_choices = %w[Rock Paper Scissors]
  computer_choice = possible_choices.shuffle[0]

  win_conditions = {
    :Rock => {
      Rock: "Draw",
      Scissors: "Win",
      Paper: "Lose"
    },
    :Paper => {
      Rock: "Win",
      Scissors: "Lose",
      Paper: "Draw"
    },
    :Scissors => {
      Rock: "Lose",
      Scissors: "Draw",
      Paper: "Win"
    }
  }

  result = win_conditions[choice.to_sym][computer_choice.to_sym]

  puts "#{computer_choice}, #{result}"
end

def remix(ingredient_arrays)
  alcohols, mixers, result = [], [], []

  ingredient_arrays.each do |pair|
    alcohols << pair[0]
    mixers << pair[1]
  end

  alcohols.shuffle!

  i = 0
  while i < ingredient_arrays.size
    result << [alcohols[i], mixers[i]]
    i += 1
  end

  result
end
