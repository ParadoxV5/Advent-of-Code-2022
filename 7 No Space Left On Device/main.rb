# frozen_string_literal: true

class Directory < Hash
  attr_accessor :parent
  protected :parent=
  attr_reader :dir_size
  def initialize
    super() do |this, name|
      mkdir = Directory.new
      mkdir.parent = this
      this[name] = mkdir
    end
    @dir_size = 0
  end
  
  ROOT = new
  
  def add_file(amount)
    @dir_size += amount
    parent&.add_file(amount)
  end
  def dir_sizes
    each_value.flat_map{ _1.dir_sizes } << dir_size
  end
end

cd = Directory::ROOT
File.foreach('input.txt', chomp: true) do |line|
  detail, _, name = line.rpartition(' ')
  case detail
    when '$ cd'
      cd = case name
        when '..'
          cd.parent
        when '/'
          Directory::ROOT
      else
        cd[name]
      end
    when '$ ls', 'dir'
      # Do nothing
  else
    cd.add_file(detail.to_i)
  end
end

dir_sizes = Directory::ROOT.dir_sizes
required_space = dir_sizes.last - 40000000 # for Part 2

puts(
  'Part 1',
  dir_sizes.lazy.filter { _1 <= 100000 }.sum,
  'Part 2',
  dir_sizes.lazy.filter { _1 >= required_space }.min
)
