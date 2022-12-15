# Model #
$part1_y = 2000000
# y2m: Part 1 (Only consider y=2000000)
class Sensor
  attr_reader :x, :y, :tx, :ty, :r
  def initialize(x, y, tx, ty)
    @x  = x
    @y  = y
    @tx = tx
    @ty = ty
    @r  = (x - tx).abs + (y - ty).abs
  end
  def x_coverage(y = $part1_y)
    d = @r - (y - @y).abs
    (@x - d)..(@x + d) unless d.negative?
  end
end

# Input #
SENSORS = File.foreach('input.txt').map { Sensor.new(*_1.scan(/-?\d++/).map!(&:to_i)) }

# Part 1 #
part1_ranges = SENSORS.map(&:x_coverage).reject(&:nil?).sort_by(&:begin).reduce([]) do|ranges, range|
  # Reduce into a list of disjoint Ranges; overlapping ranges are merged
  if ranges.empty?
    ranges << range
  else
    prev = ranges.last
    if prev.end >= range.begin
      ranges[-1] = prev.begin..[range.end, prev.end].max
    else
      ranges << range
    end
  end
  ranges
end
puts(
  'Part 1',
  # Beacon locations are within range but (obv.) contain a beacon
  part1_ranges.sum(&:size) - SENSORS
    .select { $part1_y.eql?(_1.ty) }
    .map(&:tx)
    .select {|x| part1_ranges.any? { _1.include?(x) } }
    .uniq
  .size
)

# Part 2 #
puts(
  'Part 2',
  catch(:part2) do
    4000000.times do |y|
      SENSORS
        .map { _1.x_coverage(y) }
        .reject(&:nil?)
        .sort_by(&:begin)
        .reduce do|range0, range1|
          if (range0.end - range1.begin) >= -1
            range0.begin..[range0.end, range1.end].max
          else
            throw :part2, range0.end.succ * 4000000 + y
          end
        end
    end
  end
)
