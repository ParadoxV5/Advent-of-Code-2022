# Model #
$part1_y = 2000000
# y2m: Part 1 (Only consider y=2000000)
class Sensor
  attr_reader :x, :y, :tx, :ty, :y2m_range
  def initialize(x, y, tx, ty)
    @x  = x
    @y  = y
    @tx = tx
    @ty = ty
    
    d = (x - tx).abs + (y - ty).abs - ($part1_y - y).abs
    @y2m_range = (x - d)..(x + d) if d.positive?
  end
end

# Input #
SENSORS = File.foreach('input.txt').map { Sensor.new(*_1.scan(/\d++/).map!(&:to_i)) }

# Part 1 #
y2m_ranges = SENSORS.map(&:y2m_range).reject(&:nil?).sort_by(&:begin).reduce([]) do|ranges, range|
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
  y2m_ranges.sum(&:size) - SENSORS
    .select { $part1_y.eql?(_1.ty) }
    .map(&:tx)
    .select {|x| y2m_ranges.any? { _1.include?(x) } }
    .uniq
  .size
)
