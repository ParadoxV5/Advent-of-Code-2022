class Array
  include Comparable
  alias aoc_old_cmp <=>
  def <=>(other) = aoc_old_cmp(Array(other))
end
class Integer
  alias aoc_old_cmp <=>
  def <=>(other) = aoc_old_cmp(other) || (other <=> self)&.-@
end

PACKETS = File.foreach('input.txt').filter_map { eval _1 }

puts(
  'Part 1',
  PACKETS.each_slice(2).with_index.sum do |pair, zero_based_index|
    pair.inject(&:<=) ? zero_based_index.succ : 0
  end
)

DIVIDERS = [ [[2]], [[6]] ]
PACKETS.push(*DIVIDERS)
PACKETS.sort!

puts(
  'Part 2',
  DIVIDERS.map do |divider|
    PACKETS.bsearch_index do
      divider <=> _1 or raise "uncomparable divider #{divider}"
    end&.succ
  end.inject(&:*)
)
