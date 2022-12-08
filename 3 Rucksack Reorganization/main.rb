require 'set'

class Set
  def aoc_priority
    o = first.ord
    # 'a'.ord => 97; 'A'.ord => 65;  27-65 => -38
    o > 90 ? o - 96 : o - 38
  end
end

puts('Part 1',
  File.foreach('input.txt', chomp: true).sum do |line|
    half_length = line.size / 2
    (line[...half_length].each_char.to_set & line[half_length..].each_char).aoc_priority
  end
)

puts('Part 2',
  File.foreach('input.txt', chomp: true).each_slice(3).sum do |alice, bob, charlie|
    (alice.each_char.to_set & bob.each_char & charlie.each_char).aoc_priority
  end
)
