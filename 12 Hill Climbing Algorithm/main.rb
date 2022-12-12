class String
  attr_accessor :searched
end

$bfs = []
MAP = File.foreach('input.txt', chomp: true).map.with_index do |row, y|
  row = row.chars
  if (x = row.find_index('E'))
    $bfs << [y, x]
    (row[x] = 'z').searched = true
  end
  row
end
WIDTH = MAP.first&.size || 0
HEIGHT = MAP.size

steps = 0
loop do
  $bfs2 = []
  steps += 1
  $bfs.each do |y, x|
    reachable_ord = MAP[y][x].ord.pred
    [[y+1, x], [y-1,x], [y,x-1],[y,x+1]].each do |there_pos|
      y, x = there_pos
      next if x >= WIDTH or y >= HEIGHT or there_pos.any?(:negative?)
      there = MAP[y][x]
      next if there.searched
      if there.ord >= reachable_ord
        if there <= 'a'
          puts steps
          exit
        end
        there.searched = true
        $bfs2 << there_pos
      end
    end
  end
  $bfs = $bfs2
end
