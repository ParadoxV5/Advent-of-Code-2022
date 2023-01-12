class Tree
  include Comparable
  
  attr_accessor :height, :visibility, :scenic_score
  def initialize(height)
    @height = height
    @scenic_score = 1
  end
  
  def <=>(other)
    height <=> other.height if other.respond_to?(:height)
  end
end

$grid = File.foreach('input.txt', chomp: true).map {|row| row.each_char.map { Tree.new(_1) } }

def scan # analyze leftward viewing from `tree`
  $grid.each do |row|
    row.each_with_index do |tree, x|
      visible = (x-1).downto(0).none? do |prev_x|
        row[prev_x] >= tree and tree.scenic_score *= x - prev_x
      end
      if visible
        tree.visibility = true
        tree.scenic_score *= x
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
  $grid.sum { _1.count(&:visibility) },
  'Part 2',
  $grid.flatten.map!(&:scenic_score).max
)
