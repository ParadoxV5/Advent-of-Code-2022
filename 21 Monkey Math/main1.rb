monkeys = File.foreach('input.txt', chomp: true).to_h {|line| line.split(': ', 2) }

def monkeys.yell(name)
  case self[name]
  when /\d++/
    $&.to_i
  when / ([+\-*\/]) /
    $1.to_sym.to_proc.(yell($`), yell($'))
  else
    raise "unrecognized job #{self[name]}"
  end
end

puts 'Part 1', monkeys.yell('root')
