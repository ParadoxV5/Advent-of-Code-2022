# frozen_string_literal: true

# I have identified two strategies:
# * **The conventional (not *conversion-al*)**
#   Convert the SNAFU numbers to binary numbers (real calculators count in binary),
#   do the summation, and convert the sum back to SNAFU. I’ll solve the puzzle with this strategy.
# * **The daring**
#   Do the additions directly in SNAFU, carrying (or, for negatives, borrowing) as appropriate.
#   Would be a cool challenge and I too gave it a thought, though it’s computationally inefficient.

include module SNAFU
  module_function
  
  DIGITS = {
    '0' =>  0,
    '1' =>  1,
    '2' =>  2,
    '=' => -2,
    '-' => -1
  }.freeze
  
  def snafu_to_integer(string)
    string.each_char.reduce(0) { DIGITS.fetch(_2) + _1 * 5 }
  end
  def integer_to_snafu(integer)
    # SNAFU is essentially Balanced Quinary with patent pending digits.
    # The algorithm I’m using here is adapted from
    # https://en.wikipedia.org/wiki/Balanced_ternary?oldid=1133466586#Conversion_from_ternary
    digits = integer.digits(5) # convert to quinary
    digits << 0 # Add a top-most digit: might need it to hold a carry
    digits.map!.with_index do|digit, place|
      if digit >= 3
        digit -= 5
        digits[place.succ] += 1
      end
      case digit
        when -1 then '-'
        when -2 then '='
        else digit
      end
    end
    digits.pop if digits.last == 0
    digits.reverse.join
  end
  
  self
end

puts 'Part 1', integer_to_snafu(
  File.foreach('input.txt', chomp: true).sum { snafu_to_integer(_1) }
)
