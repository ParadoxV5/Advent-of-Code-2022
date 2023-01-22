require_relative 'board2d'

# Board comprised of a single orthogonally convex shape
# Compile to indices of board edges and walls
# Local Wrap Around
class ConvexBoard < Board2D
  class LandSequence
    # `@range` must not `#exclude_end?`
    attr_reader :range, :obstructions
    def initialize(range, obstructions)
      @range, @obstructions = range, obstructions
    end
    def self.[](*array, is_land: :itself, is_obstruction:)
      # Index of first land – Index of last land
      range = array.index(&is_land)..array.rindex(&is_land)
       # Range above; Indices of obstructions within the range above
      ConvexBoard::LandSequence.new(
        range,
        range.select { array[_1].then(&is_obstruction) }
      )
    end
    
    def step(from, to = from.succ)
      if to >= from
        path = from..to
        obstructions.find { path.cover?(_1) }&.pred
      else
        path = to..from
        obstructions.reverse_each.find { path.cover?(_1) }&.succ
      end or to
    end
    def step_by(from, steps = 1)
      to = from + steps
      if range.cover?(to) # No wrap around
        step(from, to)
      else
        # step to edge, wrap, step the remaining
        is_backward = steps.negative?
        if is_backward
          [range.begin, range.end]
        else
          [range.end, range.begin]
        end => from_edge, to_edge
        stop = step(from, from_edge)
        if stop != from_edge
          stop
        elsif (is_backward ? obstructions.max : obstructions.min) == to_edge
          from_edge
        else
          step(to_edge, (to - range.begin) % range.size + range.begin)
        end
      end
    end
  end
  
  attr_reader :rows, :columns
  attr_accessor :x, :y, :facing
  def initialize(
    rows: [], columns: [],
    x: rows.fetch(0).range.begin, y: 0, facing: 0
  )
    super(x:, y:, facing:)
    @rows, @columns = rows, columns
  end
  
  def self.table_to_sequences(table, is_land: :itself, is_obstruction:)
    table.map { LandSequence[*_1, is_land:, is_obstruction:] }
  end
  def self.[](table, is_land: :itself, is_obstruction:)
    ConvexBoard.new(
      rows: table_to_sequences(table, is_land:, is_obstruction:),
      columns: table_to_sequences(table.transpose, is_land:, is_obstruction:)
    )
  end
  
  def move(steps = 1)
    case facing!
      when 0 then self.x =    rows.fetch(y).step_by(x, steps)
      when 1 then self.y = columns.fetch(x).step_by(y, steps)
      when 2 then self.x =    rows.fetch(y).step_by(x, -steps)
      when 3 then self.y = columns.fetch(x).step_by(y, -steps)
      else # should not happen
    end
  end
end

puts(
  'Part 1',
  ConvexBoard.call('input.txt') do|board|
    board_width = (board.map(&:size).max or 0)
    ConvexBoard[
      board.map { _1.ljust(board_width).bytes },
      is_land: -> { _1 != 0x20 }, # ` `
      is_obstruction: -> { _1 == 0x23 } # `#`
    ]
  end
)
