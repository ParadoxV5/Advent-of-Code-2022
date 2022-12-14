$default_column = []
# Hash[x => Array[occupied?]]
CAVE = Hash.new {|this, index| this[index] = $default_column.dup }

File.foreach('input.txt') do |rock|
  rock.scan(/\d++/).map(&:to_i).each_slice(2).each_cons(2) do |(x0, y0), (x1, y1)|
    if x0.eql?(x1)
      Range.new(*[y0, y1].sort!).each_with_object(x0) {|y, x| CAVE[x][y] = true }
    else
      Range.new(*[x0, x1].sort!).each_with_object(y0) {|x, y| CAVE[x][y] = true }
    end
  end
end

if true # Part 1: false; Part 2: true
  max_depth = CAVE.each_value.map(&:size).max.succ
  $default_column = Array.new(max_depth, false)
  $default_column << true
  CAVE.each_value { _1[max_depth] = true }
end

def CAVE.simulate(x, y)
  return false if self[x][y]
  rel_y = self[x][y..]&.find_index(&:itself)
  raise "column #{x} is bottomless" unless rel_y
  y += rel_y
  simulate(x.pred, y) or simulate(x.succ, y) or (self[x][y.pred] = true)
end

count = 0
count += 1 while CAVE.simulate(500, 0) rescue warn $!
puts count
