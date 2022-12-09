require 'set'

# ⬆+y +x➡
hx = hy = tx = ty = 0
tail_positions = Set.new # starting coördinates

File.foreach('input.txt') do |line|
  direction, _, steps = line.partition(' ')
  steps.to_i.times do
    case direction
      when 'U'
        hy += 1
      when 'D'
        hy -= 1
      when 'L'
        hx -= 1
      when 'R'
        hx += 1
    else
      warn "unknown direction #{direction}"
    end
    dx = hx - tx
    ax = dx.abs
    dy = hy - ty
    ay = dy.abs
    if ax > 1 or ay > 1 # disconnect
      tx += dx <=> 0
      ty += dy <=> 0
    end
    tail_positions.add([tx, ty])
  end
end

puts tail_positions.size
