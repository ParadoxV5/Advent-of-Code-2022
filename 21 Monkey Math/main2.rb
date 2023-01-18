class StepSolver
  class << self
    # x + a = y => x = y - a
    # x - a = y => x = y + a
    # x * a = y => x = y / a
    # x / a = y => x = y * a
    def <<(op, a)
      case op
        when :+ then ->{ _1 - a }
        when :- then ->{ _1 + a }
        when :* then ->{ _1 / a }
        when :/ then ->{ _1 * a }
        else raise ArgumentError
      end
    end
  
    # a + x = y => x = y - a
    # a - x = y => x = a - y
    # a * x = y => x = y / a
    # a / x = y => x = a / x
    def >>(op, a)
      case op
        when :+ then ->{ _1 - a }
        when :- then ->{ a - _1 }
        when :* then ->{ _1 / a }
        when :/ then ->{ a / _1 }
        else raise ArgumentError
      end
    end
    
    def call(a, op, b)
      if a.is_a?(StepSolver)
        op.equal?(:'=') ? a.(b) : a.<<(op, b)
      elsif b.is_a?(StepSolver)
        op.equal?(:'=') ? b.(a) : b.>>(op, a)
      else
        op.to_proc.(a, b)
      end
    end
  end
  
  def initialize
    # [(y, a)]
    @stack = []
  end
  
  #XXX:
  # #+, #-, #* and #/ are not implemented for StepSolver because hopefully
  # this AoC challenge does not require StepSolver-StepSolver operations
  
  def <<(op, a)
    @stack << self.class.<<(op, a)
    self
  end
  def >>(op, a)
    @stack << self.class.>>(op, a)
    self
  end
  
  def call(y) = @stack.reverse_each.reduce(y) { _2.(_1) }
end

monkeys = File.foreach('input.txt', chomp: true).to_h { _1.split(': ', 2) }
monkeys['root'][/ . /] = ' = '
monkeys['humn'] = StepSolver.new

def monkeys.call(name)
  case job = self[name]
  when /\d++/
    $&.to_i
  when / (.) /
    StepSolver.(call($`), $1.to_sym, call($'))
  else
    job
  end
end

puts 'Part 2', monkeys.call('root')
