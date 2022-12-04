# frozen_string_literal: true

puts(
  'Part 1',
  File.foreach('input.txt').count do |pair|
    # "a-b,x-y"
    a,b , x,y = pair.scan(/\d++/).map!(&:to_i)
    a, x = a..b, x..y
    a.cover?(x) or x.cover?(a)
  end
)
