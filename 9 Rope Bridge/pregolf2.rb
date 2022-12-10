N = 10 # Part 1: `2`
KNOTS = Array.new(N, 0i) # Complex suggested by Discord@sampersand#8419
TAIL_POSITIONS = []
DIRECTION_UNITS = %w[R U L D].each_with_index.to_h { [_1, 1i ** _2] }

while (direction = $stdin.getc)
  $stdin.gets.to_i.times do
    # Move head
    KNOTS[0] += DIRECTION_UNITS[direction]
    # Update each following knot
    N.times.each_cons(2) do |prev_index, succ_index|
      delta = KNOTS[prev_index] - KNOTS[succ_index]
      if delta.abs >= 2
        KNOTS[succ_index] += Complex.rect(*delta.rect.map! { _1 <=> 0 })
      end
    end
    # Record tail position
    TAIL_POSITIONS << KNOTS.last
  end
end

puts TAIL_POSITIONS.uniq.size
