head = tail = 0i
tail_positions = []
direction_units = %w[R U L D].each_with_index.to_h { [_1, 1i ** _2] }

while (direction = $stdin.getc)
  $stdin.gets.to_i.times do
    # Move head
    head += direction_units[direction]
    # Update and record tail
    delta = head - tail
    tail += Complex.rect(*delta.rect.map! { _1 <=> 0 }) if delta.abs >= 2
    tail_positions << tail
  end
end

puts tail_positions.uniq.size
