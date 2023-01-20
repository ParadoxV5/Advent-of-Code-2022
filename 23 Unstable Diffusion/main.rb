require 'set'

# Complex numbers will represent each coordinate. For further convenience,
# let the direction of positive real be East and positive imaginary be North.
# Note the puzzle only requires a relative coordinate system.

elves = File.open('input.txt') do|file|
  coord = 0i
  file.each_char.filter_map do|char|
    coord += 1
    case char
      when "\n"
        coord = coord.imag.pred.i
        nil
      when '#'
        coord
    else
      nil
    end
  end
end

relative_adjacent = [
  -1+1i  ,  1i, 1+1i  ,
  -1.to_c,      1.to_c,
  -1-1i  , -1i, 1-1i
]

# Indices to adjacent
# 0 1 2
# 3   4
# 5 6 7
proposal_indices = [
  [1, 2, 0],
  [6, 7, 5],
  [3, 0, 5],
  [4, 2, 7]
]

10.times do
  elves_set = elves.to_set # Hash set = fast `include?`
  elves = elves.map do|elf| # first half
    absolute_adjacent = relative_adjacent.map do|adjacent| #=> [open_spaces…]
      adjacent += elf
      adjacent unless elves_set.include?(adjacent)
    end
    [
      if absolute_adjacent.all?
        elf # does not do anything
      else
        proposal_index = proposal_indices.find do|indices|
          indices.all? { absolute_adjacent.fetch(_1) }
        end
        proposal_index ? absolute_adjacent.fetch(proposal_index.fetch(0)) : elf
          # proposal_index.nil? iff this elf is surrounded on all sides
      end,
      elf
    ] #=> [proposal, elf]
  end.group_by(&:first).flat_map do|proposal, pe_group| # second half
    pe_group.one? ? proposal : pe_group.map { _1.fetch(1) } # only or none
  end
  # at the end of the round
  proposal_indices.rotate!
end

puts(
  'Part 1',
  elves.map(&:rectangular).transpose.map do|ords|
    min, max = ords.minmax
    max - min + 1
  end.inject(:*) - elves.size
)
