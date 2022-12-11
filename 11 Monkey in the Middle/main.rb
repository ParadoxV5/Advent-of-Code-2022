class Monkey
  class << self
    attr_accessor :part1, :common_divisor # `common_divisor` is for optimizing Part 2
  end
  MONKEYS = []
  @common_divisor = 1
  
  attr_accessor :items, :inspect_count
  def initialize(items, operation, test_divisor, true_target, false_target)
    MONKEYS << self
    @items = items
    @operation = eval "-> old {#{operation}}"
    @test_divisor = test_divisor
    Monkey.common_divisor = Monkey.common_divisor.lcm(test_divisor)
    @true_target = true_target
    @false_target = false_target
    @inspect_count = 0
  end
  
  def inspect_items
    items.each do|item|
      item = @operation.(item)
      item /= 3 if Monkey.part1
      item %= Monkey.common_divisor # optimize Part 2
      MONKEYS[
        item % @test_divisor == 0 ? @true_target : @false_target
      ].items << item 
    end
    @inspect_count += items.size
    items.clear
  end
  def self.inspect_items
    MONKEYS.each(&:inspect_items)
  end
end

File.foreach('input.txt', '') do |monkey|
  items, operation, test = monkey.partition(/old.++/)
  Monkey.new(
    items.scan(/\d++/).drop(1).map!(&:to_i), # drop I in 'Monkey I'
    operation,
    *test.scan(/\d++/).map!(&:to_i)
  )
end

Monkey.part1 = false # <== Part 1: true-ish
(Monkey.part1 ? 20 : 10000).times { Monkey.inspect_items }
puts Monkey::MONKEYS.map(&:inspect_count).max(2).reduce(&:*)
