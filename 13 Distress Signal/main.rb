class Array
  include Comparable
  
  alias old_cmp <=>
  def <=>(other)
    other = [other] unless other.respond_to?(:each)
    old_cmp(other)
  end
end
class Integer
  alias old_cmp <=>
  def <=>(other)
    other.respond_to?(:each) ? [self] <=> other : old_cmp(other)
  end
end

puts(
  File.foreach('input.txt', '', chomp: true).with_index.sum do |pair, zero_based_index|
    pair.lines.map do |line|
      line = eval line
    end.reduce(&:<=>).positive? ? 0 : zero_based_index + 1
  end
)

ordered_packets = File.foreach('input.txt', chomp:true).reject(&:empty?).map do eval _1
end
ordered_packets.push([[2]], [[6]])
ordered_packets.sort!
puts (ordered_packets.find_index([[2]]) + 1) * (ordered_packets.find_index([[6]]) + 1)
