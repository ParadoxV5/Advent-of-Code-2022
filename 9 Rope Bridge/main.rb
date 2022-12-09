require 'set'

# [+x➡, ⬆+y]
knots = Array.new(10) { [0, 0] } # Part 1: `.new(2)`
head = knots.first # cache reference for quick access
tail = knots.last # ditto
tail_positions = Set.new

puts(
  File.foreach('input.txt').sum do |line|
    direction, _, steps = line.partition(' ')
    steps.to_i.times.count do
      # Move head
      case direction
        when 'U'
          head[1] += 1
        when 'D'
          head[1] -= 1
        when 'L'
          head[0] -= 1
        when 'R'
          head[0] += 1
      else
        warn "unknown direction #{direction}"
      end
      
      # Update each following knot
      knots.each_cons(2) do |prev, succ|
        dx, dy = prev.zip(succ).map! {|pv, sc| pv - sc }
        if dx.abs > 1 or dy.abs > 1 # disconnect
          succ[0] += dx <=> 0 # x <=> 0 => signum(x)
          succ[1] += dy <=> 0
        end
      end
      
      # Count 1 if unique tail position
      tail_positions.add?(tail)
    end
  end
)
