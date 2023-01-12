$bfs = []
MAP = File.foreach('input.txt', chomp: true).map.with_index do |row, y|
  row = row.chars
  if (x = row.find_index('E'))
    $bfs << [y, x]
    row[x] = 'z'
  end
  row
end
WIDTH = MAP.first&.size || 0
HEIGHT = MAP.size

steps = 0
loop do
  $bfs2 = []
  steps += 1
  $bfs.each do |y0, x0|
    here = MAP[y0][x0]
    next unless here
    
    [
      [y0.pred, x0],
      [y0.succ, x0],
      [y0, x0.pred],
      [y0, x0.succ]
    ].each do |there_pos|
      next if there_pos.any?(:negative?)
      there = MAP.dig(*there_pos)
      next unless there
      if there.ord >= here.ord.pred
        if there <= 'a'
          puts steps
          exit
        end
        $bfs2 << there_pos
      end
    end
    MAP[y0][x0] = nil # remove locations that have been searched
  end
  $bfs = $bfs2
end
