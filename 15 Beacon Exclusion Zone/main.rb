require 'set'
# Only consider y=part1_y for Part 1
PART1_Y = 2000000

PART1_BEACONS_XS = Set.new
EDGES = File.foreach('input.txt').flat_map do|line|
  x, y, tx, ty = line.scan(/-?\d++/).map!(&:to_i)
  PART1_BEACONS_XS << tx if PART1_Y.eql?(ty)
  r = (x - tx).abs + (y - ty).abs
  rhombus = [
    [x + r, y    ],
    [x    , y + r],
    [x - r, y    ],
    [x    , y - r]
  ]
  (-4..0).map{ rhombus[_1] }.each_cons(2).to_a
end.to_set
POINTS = EDGES
  .to_a
  .permutation(2)
  .flat_map do |((x1, y1), (x2, y2)), ((x3, y3), (x4, y4))|
  # Only process if edge1 goes +/+ or -/- direction and edge2 goes +/- or -/+ direction
    next [] unless (x1 <=> x2) == (y1 <=> y2) and (x3 <=> x4) == (y4 <=> y3)
    # Find projected intersection, which is either an intersection,
    # a polygon corner or is actually outside one or both line segments
    c = y1 - x1
    x = Rational(x3 + y3 - c, 2)
    # Discard if the intersection is not covered by both segments (corner is a pass)
    next [] unless x.eql?([x1, x2, x, x3, x4].sort![2])
    y = x + c
    next [] unless y.eql?([y1, y2, y, y3, y4].sort![2])
    [x, y].map { [_1.floor, _1.ceil] }.inject(:product)
  end
  .to_set

puts(
  'Part 1',
  # According to Part 2, there are no gaps between
  # the left-most and right-most edges of coverage
  EDGES
    .filter_map do |(x1, y1), (x2, y2)| # x of intersect with y = part1_y
      y1, y2 = y2, y1 if y1 > y2
      PART1_Y - y1 + (x1 > x2 ? x2 : x1) if (y1..y2).include?(PART1_Y)
    end
    .minmax
    .then {|left, right| right - left + 1 - PART1_BEACONS_XS.size },
  
  'Part 2',
  # Part 2 revealed that there is one and only one hole bounded by the
  # sensors’ coverage within x & y 0..4000000, and it is one location in area.
  # This strategy has identified possible boundary vertices,
  # which it then can find quartets that have the right dimensions.
  # (Proof pending to confirm that the quartet is always a hole.)
  POINTS.find do |point|
    next unless point.all? { _1.positive? and _1 <= 4000000 }
    # The point off `find` is the one with centered `x` and lowest `y`
    x, y = point.first, point.last.succ
    POINTS.include?([x.pred, y]) and
    POINTS.include?([x.succ, y]) and
    POINTS.include?([x, y.succ])
  end.then {|x, y| x * 4000000 + y.succ }
)
