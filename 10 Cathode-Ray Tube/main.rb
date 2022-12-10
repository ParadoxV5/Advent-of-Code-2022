$x = 1 # initial value
$cycle = 0
$sum = 0

def do_cycle
  print ($cycle % 40 - $x).abs <= 1 ? '@' : ' ' # Part 2

  $cycle += 1
  
  case $cycle % 40
    when 20 # Part 1
      $sum += $x * $cycle
    when 0 # Part 2
      puts
  else
    # do nothing
  end
end

# Process instructions (input)
File.foreach('input.txt') do |line|
  do_cycle
  if (v = line[/addx (-?\d+)/, 1])
    do_cycle
    $x += v.to_i
  end
end

puts
puts "Part 1: #{$sum}"
