matches = File.readlines('input.txt', chomp: true) # each line without the line break

# Actually easier and less brainpower to just hardcode the combinations out
# You chose:
#    Rock, Paper, Scissors
#      1 ,    2 ,    3
puts(
  [  [nil, # Part 1 key
    'B X', 'C Y', 'A Z', # 0
    'A X', 'B Y', 'C Z', # 3
    'C X', 'A Y', 'B Z'  # 6
  ], [nil, # Part 2 key
    'B X', 'C X', 'A X', # 0
    'A Y', 'B Y', 'C Y', # 3
    'C Z', 'A Z', 'B Z'  # 6
  ]  ].map!.with_index do |key, i|
    puts "Part #{i.succ}"
    # Convert to `match => score` hash for fast indexing
    key = key.each_with_index.to_h
    matches.sum { key[_1] } # sum as score
  end
)
