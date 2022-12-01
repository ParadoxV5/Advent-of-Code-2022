# frozen_string_literal: true

elves_calories = []

File.open('input.txt') do |f|
  while (elf = f.gets(''))
    elves_calories.push(elf.lines.map!(&:to_i).sum)
  end
end

# Part 1
#elves_calories.max

elves_calories.sort!
puts elves_calories[-3..-1].sum
