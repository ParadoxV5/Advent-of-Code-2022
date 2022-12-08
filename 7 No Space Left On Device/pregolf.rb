# Assumes that each directory is visited at most once
# (i.e., the input is a pre-order tree traversal)

DIR_SIZES = []
def process_directory
  size = 0
  $stdin.each_line do |line|
    break if line['..']
    size += line['d '] ? process_directory : line.to_i
  end
  DIR_SIZES << size
  size
end

required_space = process_directory - 4e7

puts(
  DIR_SIZES.sum { _1 <= 1e5 ? _1 : 0 },
  DIR_SIZES.filter { _1 >= required_space }.min
)
