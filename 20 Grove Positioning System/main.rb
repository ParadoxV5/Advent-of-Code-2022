# So far, we have used the built-in {Array} for stacks and queues,
# despite their inefficiency compared to a Linked List.
# This time, though – I actually need a Doubly Linked List.
# The unorthodox operations for tonight’s challenge is too taxing,
# both space and time, for conventional inflexible arrays.
class DLLNode 
  attr_accessor :value, :prev1, :next1
  def initialize(value)
    @value = value
  end
  
  def self.link(*nodes) = nodes.each_cons(2) do|a, b|
    a.next1 = b
    b.prev1 = a
  end
  
  def prev(n = 1)
    n.times.reduce(self) { |pointer, _| pointer.prev1 }
  end
  def next(n = 1)
    n.times.reduce(self) { |pointer, _| pointer.next1 }
  end
  
  def shift(n)
    return [prev1, self, next1] if n.zero?
    # |  neg. n  | idx |  pos. n  |
    # |:--------:|-----|:--------:|
    # | new_prev | n-1 |          |
    # | new_next | n   |          |
    # |          | …   |          |
    # | old_prev |  -1 | old_prev |
    # |   self   |  0  |   self   |
    # | old_next |  +1 | old_next |
    # |          | …   |          |
    # |          | n   | new_prev |
    # |          | n+1 | new_next |
    old_prev, old_next = prev1, next1
    # remove
    DLLNode.link(old_prev, old_next)
    # insert
    if n.negative?
      new_next = prev(-n)
      DLLNode.link(new_next.prev1, self, new_next)
    else
      new_prev = self.next(n)
      DLLNode.link(new_prev, self, new_prev.next1)
    end
  end
end

$part2 = true # Part 1: false

pointer = nil
init_arr = File.foreach('input.txt').map do|line|
  line = line.to_i
  line *= 811589153 if $part2 # apply decryption key
  node = DLLNode.new(line)
  pointer = node if line.zero?
  node
end
raise '0 not found' unless pointer

# Circular Link
DLLNode.link(*(init_arr + [init_arr.first]))

if $part2
  size_while_shifting = init_arr.size.pred
  # Bane of Humongous Numbers (not a trademark)
  shift_amounts = init_arr.map { _1.value % size_while_shifting }
  10.times { init_arr.zip(shift_amounts) { _1.shift(_2) } }
else # Part 1
  init_arr.each { _1.shift(_1.value) }
end

puts(
  "Part #{$part2 ? 2 : 1}",
  3.times.sum do
    pointer = pointer.next(1000)
    pointer.value
  end
)
