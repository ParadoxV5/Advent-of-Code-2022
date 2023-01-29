# This puzzle is just a regular ol’ maze solving but with moving walls.

# ⬇+imag +real➡
# Origin (0+0i): top-left of valley excluding the outer ring of walls

require 'set' # Used for BFS only

def multi_hash = Hash.new {|hsh, key| hsh[key] = [] }
steps = {
  '^' => -1i,
  'v' =>  1i,
  '<' => -1.to_c,
  '>' =>  1.to_c,
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

timeout = 512
dodge_blizzards = ->(start, target)do
  bfs = Set[start]
  (1...timeout).each do|minute|
    puts minute if $VERBOSE
    
    # Forecast blizzards’ move
    blizzards = blizzards.each_with_object(multi_hash) do|(xy, deltas), hsh|
      deltas.each do|delta|
        x, y = (xy + delta).rectangular
        hsh[Complex(x % width, y % height)] << delta
      end
    end
    
    # BFS, using a HashSet to eliminate repeats
    # (previously with immobile obstacles, repetition eliminations were done with `traversed` flags or equivalent)
    # [P.S.] Turns out that this repeats eliminator reduces the decision tree from `O(5ⁿ)` –
    # move one of 4 directions or wait still for each minute – to `O(kn)` –
    # there’s a limited number of positions the expedition can be at (`k`) at any given minute
    # (more precisely, up to `valley width × valley length - number of blizzards` positions).
    bfs = bfs.each_with_object(Set.new) do|expedition, set|
      steps.each do|_, xy|
        xy += expedition
        # Always check target and allow waiting at the start first
        # (They are otherwise out-of-bounds)
        return minute if xy == target
        if xy != start
          x, y = xy.rectangular
          next if blizzards.has_key?(xy) or
             # ram into a wall
            x.negative? or y.negative? or x >= width or y >= height # [^1]
        end
        set << xy
      end
    end
  end
end

here, there = -1i, Complex(width.pred, height)
part1 = dodge_blizzards.(here, there)
puts(
  'Part 1',
  part1,
  'Part 2',
  part1 + dodge_blizzards.(there, here) + dodge_blizzards.(here, there)
)

# [^1]:
#   The puzzle allows walking through a blizzard next door that is moving in the opposite direction,
#   for it only compares the positions of the blizzard and the expedition and finds the two not shared.
#   I’m not sure what’s the logic behind that.
#   Perhaps it relate to the enigmatic mechanics behind the Conservation of Blizzard Energy?
