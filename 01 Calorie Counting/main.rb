puts File.
  foreach('input.txt'). # each line
  slice_after(/^$/). # group using blank line as dividers
  map { _1.sum(&:to_i) }. # map to sum as integers
# Part 1:
#.max
# Part 2:
max(3).sum
