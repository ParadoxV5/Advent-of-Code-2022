# frozen_string_literal: true

puts 'Part 1'

# Actually easier and less brainpower to just hardcode the combinations out
scores = [nil,
  # You chose:
  # Rck,   Ppr,   Ssr
  #  1 ,    2 ,    3
  'B X', 'C Y', 'A Z', # 0
  'A X', 'B Y', 'C Z', # 3
  'C X', 'A Y', 'B Z'  # 6
].each_with_index.to_h # match => score

puts File.
  foreach('input.txt', chomp: true). # each line without the line break
  map { scores[_1] }. # map to possibility, index = the score
sum
