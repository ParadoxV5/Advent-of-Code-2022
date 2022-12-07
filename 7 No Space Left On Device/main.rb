# frozen_string_literal: true

class Directory < Hash
  attr_reader :parent
  attr_reader :dir_size
  def initialize(parent)
    @parent = parent
    @dir_size = 0
  end
  
  def add_file(amount)
    @dir_size += amount
    parent&.add_file(amount)
  end
  def dir_sizes
    each_value.flat_map{ _1.dir_sizes } << dir_size
  end
end

cd = ROOT = Directory.new(nil)
File.foreach('input.txt', chomp: true) do |line|
  next if line.eql?('$ cd /') # already created `ROOT`
  detail, _, name = line.rpartition(' ')
  case detail
  when '$ cd'
    cd = name.eql?('..') ? cd.parent : cd[name]
  when 'dir'
    cd[name] = Directory.new(cd)
  else
    cd.add_file(detail.to_i)
  end
end

dir_sizes = ROOT.dir_sizes
required_space = dir_sizes.last - 40000000 # for Part 2

puts(
  'Part 1',
  dir_sizes.lazy.filter { _1 <= 100000 }.sum,
  'Part 2',
  dir_sizes.lazy.filter { _1 >= required_space }.min
)
