# frozen_string_literal: true

puts(
  File.foreach('input.txt').count do |pair|
    # "a-b,x-y"
    a,b , x,y = pair.scan(/\d++/).map!(&:to_i)
    # Part 1: a..b contains x..y if a<=x and y<=b, vice versa
    #(a <= x and y <= b) or (x <= a and b <= y)
    # Part 2: Does not overlap if b<x or y<a
    b >= x and y >= a
  end
)
