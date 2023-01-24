# In summary, this is an **Open Vehicle Routing Problem with Decreasing Profits and Time Constraint**.
# (Vehicle Routing Problem = Multiple Traveling Salespersons Problem with some cities optional.)
# We have one “vehicle/salesperson” for Part 1 and two “vehicles/salespersons” for Part 2.

# Data Structure Component
class WeightedNode
  attr_accessor :value, :traversed
  attr_reader :neighbors
  def initialize(value)
    @value = value
    @neighbors = Hash.new
  end
  
  def [](...) = neighbors.[](...)
  def []=(...)
    neighbors.[]=(...)
  end
  
  def unvisited_neighbors = neighbors.reject {|neighbor, _| neighbor.traversed }
  
  def shallow_clone = self.class.new(value)
  def inspect = "WeightedNode(#{value})[#{neighbors.size} neighbors]"
end

# Collect raw data
ALL_VALVES = Hash.new {|this, key| this[key] = WeightedNode.new(0) }
File.foreach('input.txt', chomp: true) do |line|
  match = (
    /^Valve (\S+) has flow rate=(\d++); tunnels? leads? to valves? (.+)$/
  ).match(line)
  valve = ALL_VALVES[match[1]]
  valve.value = match[2].to_i
  match[3].split(', ') { valve[ALL_VALVES[_1]] = 0 }
end

# As with any VRP,
# we reduce the searching graph to a much more concise scope by transforming it into a weighted complete graph where:
# * The vertices are the starting room AA plus only the working valves (we are not interested in the ineffective ones);
# * The edges connect interested valve (either is working or is AA) to every other interested ones; and
# * The weights are the shortest time to tunnel to the valve on the other side __plus__ one minute for opening it.
# 
# The simplification step is a multiple-pairs shortest paths problem:
# https://en.wikipedia.org/wiki/Shortest_path_problem#All-pairs_shortest_paths
# Specifically, the graph is __undirected and unweighted__; but more importantly,
# the graph is also __sparse__ (at least true for my input).
# My algorithm of choice is the classical BFS applied for each unordered pair of nodes,
# utilizing that _most_ of my input are uninterested valves for a time complexity of `EN²-EN ∈ EN²`.
# In contrast, the popular Roy–Floyd–Warshall requires computing every pair every time
# (including pairs of uninterested valves), resulting the full time complexity of `2V³ ∈ V³` [^fwt].
# (`E` is the number of edges, `V` is the number of all valves, and `N` is the working valves.)
# While `N ≤ V` and `2(V-1) ≤ E ≤ V(V-1)` for arbitrary scenarios, our (at least my) case has `E ≅ 2V` and a tiny `N`.
# [^fwt]: https://en.wikipedia.org/wiki/Floyd%E2%80%93Warshall_algorithm?oldid=1132656059#Time_analysis
selected_valves = ALL_VALVES.reject { _2.value.zero? }
selected_valves['AA'] = ALL_VALVES.fetch('AA')
  # Do not `reject!` the starting room AA even if it has 0 `value`
INTERESTED_VALVES = selected_valves.transform_values(&:shallow_clone)
  # Fresh copies with unset neighbors
timeout = ALL_VALVES.size # max travel every other node + 1min opening
selected_valves.to_a.combination(2) do|(aa, a), (bb, b)|
  i = bb + aa
  a2, b2 = INTERESTED_VALVES[aa], INTERESTED_VALVES[bb]
  a2[b2] = b2[a2] = catch :bfs do
    bfs = [a]
    2.upto(timeout) do|minute| # +1min opening, start with 1min tunneling
      bfs = bfs.flat_map do|ptr|
        ptr.traversed = i
        ptr.neighbors.each_key.filter_map do|neighbor|
          throw :bfs, minute if b.equal?(neighbor)
          neighbor unless neighbor.traversed == i # Optimize by reüsing flag var
        end
      end
    end
    raise "No path from #{a} to #{b}"
  end
end

# Brute-Force (it __is__, pretty much) Recursive Depth-First Search
def maximum_release(minutes, here = INTERESTED_VALVES.fetch('AA'))
  here.traversed = true
  max_others = here.unvisited_neighbors
    .select {|_, weight| minutes > weight } # only consider reachable ones
    .map {|neighbor, weight| maximum_release(minutes - weight, neighbor) }
    .max
  here.traversed = false
  profit = here.value * minutes
  profit += max_others if max_others
  profit
end
puts 'Part 1', maximum_release(30)
