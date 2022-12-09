N = 10 # Part 1: `2`
XS = Array.new(10, 0)
YS = Array.new(10, 0)
TAIL_POSITIONS = []

while (direction = $stdin.getc)
  $stdin.gets.to_i.times do
    # Move head
    (/[UD]/.match?(direction) ? XS : YS)[0] += /[UR]/.match?(direction) ? 1 : -1
    # Update each following knot
    N.times.each_cons(2) do |prev_index, succ_index|
      dx = XS[prev_index] - XS[succ_index]
      dy = YS[prev_index] - YS[succ_index]
      if dx.abs > 1 or dy.abs > 1
        XS[succ_index] += dx <=> 0
        YS[succ_index] += dy <=> 0
      end
    end
    # Record tail position
    TAIL_POSITIONS << [XS.last, YS.last]
  end
end

p TAIL_POSITIONS.uniq.size
