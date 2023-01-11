class Valve
  attr_accessor :rate, :traversed, :open_duration
  attr_reader :neighbors
  def initialize(rate = 0, *neighbors)
    @rate = rate
    @neighbors = neighbors
    @traversed = false
  end
  
  def unvisited_neighbors = neighbors.reject(&:traversed)
  
  def <=>(other) = rate <=> other.rate
  def inspect = "GraphNode(#{rate})[#{neighbors.size} neighbors]"
end

VALVES = Hash.new {|this, key| this[key] = Valve.new }

INPUT_REGEXP = /^Valve (\S+) has flow rate=(\d++); tunnels? leads? to valves? (.+)$/
File.foreach('input.txt', chomp: true) do |line|
  id, rate, neighbors = INPUT_REGEXP.match(line).captures
  valve = VALVES[id]
  valve.rate = rate.to_i
  valve.neighbors.replace(neighbors.split(', ').map { VALVES[_1] })
end

# Quick inspection suggests that, with my input,
# I might as well open as many valves ASAP for Part 1
# warn(
#   VALVES.each_value.count do|valve|
#     working_neighbors = valve.neighbors.filter_map do|neighbor|
#       rate = neighbor.rate
#       rate if rate.positive?
#     end
#     warn working_neighbors.inspect if working_neighbors.size >= 2
#     valve.rate.positive? and not working_neighbors.empty?
#   end
# )

to_open = nil # valve to open this minute or `nil` if should search
bfs = [VALVES['AA']]
(0...30).reverse_each do |minutes_left| # each minute
  if to_open # spend a minute to open a valve
    to_open.open_duration = minutes_left
    VALVES.each_value do|valve| # Forget traversed status of all closed valves
      valve.traversed = false
    end
    bfs = [to_open] # keep going from `to_open`
    to_open = nil
  else # keep (breadth-first) searching
    bfsq = []
    best = bfs.filter_map do |valve|
      valve.traversed = true
      neighbors = valve.unvisited_neighbors
      bfsq << neighbors
      neighbors.reject(&:open_duration).max
    end.max
    if best and best.rate.positive?
      to_open = best
    else
      bfs = bfsq.flatten.uniq
    end
  end
end
puts(
  'Part 1',
  VALVES.each_value.sum { _1.open_duration&.*(_1.rate) or 0 }
)
