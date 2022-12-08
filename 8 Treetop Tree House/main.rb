# frozen_string_literal: true

class String
  attr_accessor :aoc_visibility
end

$grid = File.foreach('input.txt', chomp: true).map { _1.chars }

def scan
  $grid.each do |row|
    max_tree = ' '
    row.first&.aoc_visibility = true
    row.each do |tree|
      if tree > max_tree # taller than all previous trees
        tree.aoc_visibility = true
        max_tree = tree
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

puts $grid.sum { _1.count(&:aoc_visibility) }
