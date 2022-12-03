# frozen_string_literal: true
require 'set'

puts('Part 1',
  File.foreach('input.txt', chomp: true).sum do |line|
    half_length = line.size / 2
    (line[...half_length].each_char.to_set & line[half_length..].each_char).sum do |x|
      x = x.ord
      # 'a'.ord => 97; 'A'.ord => 65;  27-65 => -38
      x > 90 ? x - 96 : x - 38
    end
  end
)
