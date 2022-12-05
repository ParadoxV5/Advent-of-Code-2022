# frozen_string_literal: true

# Setup
drawing, procedure = File.readlines('input.txt', '') # read as paragraphs
num_of_stacks = drawing[/\d+\s+\z/].to_i
stacks = Array.new(num_of_stacks) { [] }

# Parse drawing
drawing
  .each_line
  .reverse_each # bottom-to-top
  .drop(2) # skip last line break and the numbers
.each do |line|
  # `[A] [B] [C]`
  #   1   5   9
  num_of_stacks.times do |stack_index|
    crate = line[stack_index * 4 + 1]
    stacks[stack_index].push(crate) unless crate.eql?(' ')
  end
end
stacks.prepend([]) # Drawing does not have Stack 0

# Parse procedure
procedure.each_line do |line|
  count, from, to = line.scan(/\d++/).map!(&:to_i)
  # Part 1:
  #stacks[to].push(*stacks[from].pop(count).reverse!)
  # Part 2:
  stacks[to].push(*stacks[from].pop(count))
end

puts(stacks.map(&:last).join)
