require 'set'

# Coördinate System:
# Up = +Imag; Right = +Real
# Bottom left of chamber: 0+0i

WIDTH = 7
# Start with a row of rocks as floor
CHAMBER_ROCKS = WIDTH.times.map(&:to_c).to_set
class << CHAMBER_ROCKS
  def highest = max_by(&:imag)
end

# Infinite enumerator of falling rock templates (requires manual `#dup`)
# Real coord is absolute, Imag coord is relative to bottom of rock
ROCK_STREAM = [
  (2..5).to_a,
  [2+1i, 3+1i, 4+1i, 3+2i, 3+0i],
  [2+0i, 3+0i, 4+0i, 4+1i, 4+2i],
  4.times.map { 2 + _1.i },
  [2+0i, 3+0i, 2+1i, 3+1i]
].cycle

# Infinite enumerator of jets as speed vectors
JETS_STREAM = File.read('input.txt').chomp.chars.map do|arrow|
  case arrow
    when '>' then  1
    when '<' then -1
  else
    warn 'unknown input ' + arrow
    0
  end
end.cycle

2022.times do
  falling_rock = ROCK_STREAM.next.each_with_object(
    (CHAMBER_ROCKS.highest.imag + 4).i
  ).map { _1 + _2 }
  loop do #p falling_rock; raise if falling_rock.first.imag < -3
    # be pushed by a jet
    moved_rock = falling_rock.each_with_object(JETS_STREAM.next).map { _1 + _2 }
    falling_rock = moved_rock unless moved_rock.any? do|r|
      x = r.real
      x.negative? or x >= WIDTH or CHAMBER_ROCKS.include?(r)
    end
    # fall one unit down
    moved_rock = falling_rock.each_with_object(-1i).map { _1 + _2 }
    if moved_rock.any? { |r| CHAMBER_ROCKS.include?(r) } # Collide
      CHAMBER_ROCKS.merge(falling_rock)
      break
    end # else
    falling_rock = moved_rock
  end
end
puts('Part 1', CHAMBER_ROCKS.highest.imag)
