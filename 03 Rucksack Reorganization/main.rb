require 'set'

def priority(enum)
  ord = enum.first.ord
  # 'a'.ord => 97; 'A'.ord => 65;  27-65 => -38
  ord > 0x60 ? ord - 96 : ord - 38
end

puts('Part 1',
  File.foreach('input.txt', chomp: true).sum do |line|
    half_length = line.size / 2
    priority(line[...half_length].each_char.to_set & line[half_length..].each_char)
  end
)

puts('Part 2',
  File.foreach('input.txt', chomp: true).each_slice(3).sum do |alice, bob, charlie|
    priority(alice.each_char.to_set & bob.each_char & charlie.each_char)
  end
)
