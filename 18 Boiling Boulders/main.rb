require 'set'
CUBES = File.foreach('input.txt').map { _1.split(',').map(&:to_i) }.to_set

puts CUBES.flat_map {|x, y, z| [
  [x.pred, y, z],
  [x.succ, y, z],
  [x, y.pred, z],
  [x, y.succ, z],
  [x, y, z.pred],
  [x, y, z.succ]
] }.count {|surface| not CUBES.include?(surface) }
