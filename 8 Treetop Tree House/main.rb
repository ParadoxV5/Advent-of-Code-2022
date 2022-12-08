# frozen_string_literal: true

class String
  attr_accessor :aoc_visibility
  attr_accessor :aoc_scenic_score
end

$grid = File.foreach('input.txt', chomp: true).map {|row| row.chars.each { _1.aoc_scenic_score = 1 } }

def scan # analyze leftward viewing from `tree`
  $grid.each do |row|
    row.each_with_index do |tree, x|
      visible = (x-1).downto(0).none? do |prev_x|
        row[prev_x] >= tree and tree.aoc_scenic_score *= x - prev_x
      end
      if visible
        tree.aoc_visibility = true
        tree.aoc_scenic_score *= x
      end
    end
  end
end

scan
$grid.each(&:reverse!)
scan
$grid = $grid.transpose
scan
$grid.each(&:reverse!)
scan

puts(
  'Part 1',
  $grid.sum { _1.count(&:aoc_visibility) },
  'Part 2',
  $grid.flatten.map!(&:aoc_scenic_score).max
)
