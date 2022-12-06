# frozen_string_literal: true

# For both numbers, use `4` for Part 1 and `14` for Part 2
puts File.open('input.txt') { _1.each_char.each_cons(4).find_index {|chars| chars.uniq!.nil? } } + 4
