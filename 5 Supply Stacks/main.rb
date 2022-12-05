# frozen_string_literal: true

File.open('input.txt') do |file|
  # Parse the drawing
  stacks = file
    .readline('') # drawing
    .each_line.reverse_each # bottom-to-top
    .drop(2) # skip last line break and the numbers
    .map do |line|
      # line => '[A]␠[B]␠[C]␤'
      line.scan(/..../m).map! { _1[1] }
      #    _ => ['A','B','C']
  end.transpose
    .each { |stack| stack.index(' ')&.then { stack.slice!(_1..) } }
    .prepend([]) # plus an empty Stack 0
  
  # Parse the procedures
  file.each_line do |line|
    count, from, to = line.scan(/\d++/).map!(&:to_i)
    # Part 1:
    #stacks[to].push(*stacks[from].pop(count).reverse!)
    # Part 2:
    stacks[to].push(*stacks[from].pop(count))
  end
  
  $stdout.puts(stacks.map!(&:last).join)
end
