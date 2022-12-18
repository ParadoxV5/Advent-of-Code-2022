require 'set'

cubes = File.foreach('input.txt').map { _1.split(',').map(&:to_i) }
cubes_set = cubes.to_set

def neighbors(c)
  x, y, z = *c
  [
    [x.pred, y, z],
    [x.succ, y, z],
    [x, y.pred, z],
    [x, y.succ, z],
    [x, y, z.pred],
    [x, y, z.succ]
  ]
end

surfaces = cubes.flat_map { neighbors(_1) }.reject { cubes_set.include?(_1) }

puts 'Part 1', surfaces.size

# Strategy for Part 2:
# identify all air that is reachable from a cube of air that is known to be non-trapped
# All unreachable air are pockets trapped off from outside
# (Using BFS again because DFS costs too much memory and raised SystemStackError 😓)

dim_min, dim_max = cubes.flatten.minmax
air_to_search = Range.new(dim_min.pred, dim_max.succ).to_a.repeated_permutation(3).reject { cubes_set.include?(_1) }.to_set
surfaces_to_filter = surfaces.to_set

bfs = [ Array.new(3, dim_min) ]
while (this = bfs.pop)
  # Delete from listings, then queue up neighbors if valid
  surfaces_to_filter.delete(this)
  bfs.push(*neighbors(this)) if air_to_search.delete?(this)
end

puts 'Part 2', surfaces.count { not surfaces_to_filter.include?(_1) }
