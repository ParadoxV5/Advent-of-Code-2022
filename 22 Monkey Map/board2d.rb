# frozen_string_literal: true

class Board2D
  def self.read_file(filename)
    *board, _, instructions = File.readlines(filename, chomp: true)
    [board, instructions]
  end
  def self.call(filename, &blk)
    board, instructions = read_file(filename)
    board = (blk&.(board) or new)
    instructions.scan(/\d++|./) { board.(_1) }
    board.password
  end
  
  attr_accessor :x, :y, :facing
  def initialize(x: 0, y: 0, facing: 0)
    @x, @y, @facing = x,  y,  facing
  end
  
  def row = y.succ
  def column = x.succ
  def facing! = self.facing %= 4
  def password = 1000 * row + 4 * column + facing!
  
  def move(steps = 1)
    case facing!
      when 1 then self.y += steps
      when 2 then self.x -= steps
      when 3 then self.y -= steps
      else        self.x += steps # 0
    end
  end
  
  def l = self.facing -= 1
  def r = self.facing += 1
  def call(instruction)
    case instruction
      when 'R' then r
      when 'L' then l
      else move(Integer(instruction))
    end
    self
  end
end
