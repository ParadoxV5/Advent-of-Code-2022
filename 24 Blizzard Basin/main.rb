# This puzzle is just a regular ol’ maze solving but with moving walls.

# ⬇+imag +real➡
# Origin (0+0i): top-left of valley excluding the outer ring of walls

require 'set' # Used for BFS only

def multi_hash = Hash.new {|hsh, key| hsh[key] = [] }
steps = {
  # Specifically ordered to prioritize directions that go towards the exit
  '>' =>  1.to_c,
  'v' =>  1i,
  '<' => -1.to_c,
  '^' => -1i,
  nil =>  0.to_c
}

blizzards, width, height = File.open('input.txt') do|input|
  w = input.readline.size - 3
    # also consumes top wall; -3 for the left wall, right wall, and newline
  
  xy = -1.to_c # -1 for left wall
  hsh = multi_hash
  input.each_char do|char|
    if (delta = steps[char])
      hsh[xy] << delta
    elsif char == "\n"
      xy = Complex(-2, xy.imag.succ) # -2 for the left wall & the += 1 coming up
    end
    xy += 1
  end
  
  [hsh, w, xy.imag.pred] # -1i for the bottom wall
end

entrance, target = -1i, Complex(width.pred, height)
bfs = Set[entrance]
minute = 0
loop do
  minute += 1
  puts minute if $VERBOSE
  
  # Forecast blizzards’ move
  blizzards = blizzards.each_with_object(multi_hash) do|(xy, deltas), hsh|
    deltas.each do|delta|
      x, y = (xy + delta).rectangular
      hsh[Complex(x % width, y % height)] << delta
    end
  end
  
  # BFS, using a HashSet to eliminate repeats
  # (previously with immobile obstacles,
  #  repetition eliminations were done with `traversed` flags or equivalent)
  bfs = bfs.each_with_object(Set.new) do|expedition, set|
    steps.each do|_, xy|
      xy += expedition
      if xy == target
        puts 'Part 1', minute
        exit
      end
      
      if xy != entrance
        # Always allow waiting at the entrance (which is otherwise out-of-bounds)
        x, y = xy.rectangular
        next if blizzards.has_key?(xy) or
           # ram into a wall
          x.negative? or y.negative? or x >= width or y >= height
      end
      set << xy
    end
  end
end
