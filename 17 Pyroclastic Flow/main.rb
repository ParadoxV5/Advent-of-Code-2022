require 'set'

# Coördinate System:
# Up = +Imag; Right = +Real
# Bottom left of chamber: 0-`height`i
# Up/Down is relative to keep most numbers small for Part 2
# `height` is the topmost layer of rock parts, with relative Up/Down of 0

WIDTH = 7
# Start with a row of rocks as floor
CHAMBER_ROCKS = WIDTH.times.map(&:to_c).to_set
class << CHAMBER_ROCKS
  attr_accessor :height
end
CHAMBER_ROCKS.height = 0

# Templates for summoning new falling rocks via {Array#dup} or similar
# Real coord is absolute, Imag coord is relative to topmost layer of still rocks
ROCK_TEMPLATES = [
  (2..5).map { _1 + 4i },
  [2+5i, 3+5i, 4+5i, 3+6i, 3+4i],
  [2+4i, 3+4i, 4+4i, 4+5i, 4+6i],
  (4..7).map { 2 + _1.i },
  [2+4i, 3+4i, 2+5i, 3+5i]
]
# Infinitely-looping {Enumerator} of {ROCK_TEMPLATES}
# (requires manual {Array#dup} or similar)
ROCK_TEMPLATES_STREAM = ROCK_TEMPLATES.cycle

# Jets as speed vectors
JETS = File.read('input.txt').chomp.chars.map do|arrow|
  case arrow
    when '>' then  1
    when '<' then -1
  else
    warn 'unknown input ' + arrow
    0
  end
end
# Infinite enumerator of {JETS}
JETS_STREAM = JETS.cycle

def drop_rock
  falling_rock = ROCK_TEMPLATES_STREAM.next
  loop do
    #raise if falling_rock.first.imag < -0x44 # In case I fked up
    
    # be pushed by a jet
    moved_rock = falling_rock.each_with_object(JETS_STREAM.next).map { _1 + _2 }
    falling_rock = moved_rock unless moved_rock.any? do|r|
      x = r.real
      x.negative? or x >= WIDTH or CHAMBER_ROCKS.include?(r)
    end
    
    # fall one unit down
    moved_rock = falling_rock.each_with_object(-1i).map { _1 + _2 }
    break if moved_rock.any? { |r| CHAMBER_ROCKS.include?(r) }
    falling_rock = moved_rock
  end
  
  CHAMBER_ROCKS.merge(falling_rock)
  gained_height = CHAMBER_ROCKS.max_by(&:imag).imag
  CHAMBER_ROCKS.map!.with_object(gained_height.i) {|r, gained| r - gained }
  # Discard bottommost parts to ~~save memory~~
  # limit range for Part 2’s repeat detection
  # (fingers-crossed that it won’t break emulation)
  # (tweak `0x40` for best performance vs. accuracy tradeoff)
  CHAMBER_ROCKS.keep_if { _1.imag > -0x40 }
  CHAMBER_ROCKS.height += gained_height
end

# Part 1: ```
# 2022.times { drop_rock }; puts CHAMBER_ROCKS.height
# ```
# Part 2:
# 1_000_000_000_000 => a trillion 👀
# The trick is that the rock stacking pattern should eventually repeat itself
HISTORY_HASH = {} # `CHAMBER_ROCKS.dup => [i, height]`
NUM_OF_ROCKS = 1_000_000_000_000
puts(
  NUM_OF_ROCKS.times do |i|
    drop_rock
    if (prev_iteration, prev_i = HISTORY_HASH[CHAMBER_ROCKS])
      repeat_delta_height = CHAMBER_ROCKS.height - prev_i
      repeat_times, repeats_remainder =
        # i started counting from `0` rather than `1` as in ‘Rock #1’ 
        (NUM_OF_ROCKS - prev_iteration.succ)
          .divmod(i - prev_iteration)
      repeats_remainder.times { drop_rock }
      break(
        # delta each repeat * (times to repeat - 1) + height after 1st repeat
        repeat_delta_height * repeat_times.pred + CHAMBER_ROCKS.height
      )
    else
      HISTORY_HASH[CHAMBER_ROCKS.dup] = [i, CHAMBER_ROCKS.height]
    end
  end
)
