# frozen_string_literal: true

puts(
  File.foreach('input.txt').count do |pair|
    # "a-b,x-y"
    a,b , x,y = pair.scan(/\d++/).map!(&:to_i)
    # Part 1
    #a, x = a..b, x..y
    #a.cover?(x) or x.cover?(a)
    # Part 2: Does not overlap if b<x or y<a
    b >= x and y >= a
  end
)
