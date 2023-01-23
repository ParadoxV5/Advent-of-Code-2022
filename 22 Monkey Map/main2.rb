require_relative 'board2d'

# Board is the net of a `SIDE_LENGTH`³ cube
# Brute-force with char table
# Note: The code currently requires hard-coding the correspondence of the net.
# Ideally an algorithm would automate the cube net traversal.
class CubeNetBoard < Board2D
  class CubeFace
    # [➡[CubeFace, rotation], ⬇[…], ⬅[…], ⬆[…]]
    # rotation: 0 => no turn, 1 = turn right, 2 = U-turn, 3 = turn left
    attr_accessor :neighbors
    def initialize(neighbors = [])
      @neighbors = neighbors
    end
  end
  
  # nil => void, false => obstruction, true => open
  attr_reader :net
  # [CubeFace => its block position on the net]
  # `x`, `y` and `facing` are local to `current_face`
  attr_reader :current_face
  attr_reader :side_length
  def initialize(
    net, face_coords, side_length,
    y: 0, x: 0, facing: 0
  )
    super(x:, y:, facing:)
    @net, @side_length = net, side_length
    # `@bx` and `@by` are cache for absolute coords offset for `current_face`
    @face_coords =
      face_coords.transform_values {[side_length * _1, side_length * _2] }
    @current_face, (@bx, @by) = @face_coords.first
  end
  
  def global_x = @bx + x
  def global_y = @by + y
  
  def move(steps = 1)
    sl, x2, y2, facing2, face2, bx2, by2 =
      side_length, x, y, facing!, current_face, @bx, @by
    steps.times do
      
      has_wrapped = case facing2
        when 1 
          y2 += 1
          y2 -= sl if y2 >= sl
        when 2
          x2 -= 1
          x2 += sl if x2.negative?
        when 3
          y2 -= 1
          y2 += sl if y2.negative?
        else # 0
          x2 += 1
          x2 -= sl if x2 >= sl
      end
      if has_wrapped
        face2, rotate = face2.neighbors.fetch(facing2)
        bx2, by2 = @face_coords.fetch(face2)
        facing2 += rotate
        case rotate
          when 1
            x2, y2 = sl - y2.succ, x2
          when 2
            x2, y2 = sl - x2.succ, sl - y2.succ
          when 3
            x2, y2 = y2, sl - x2.succ
          else # 0
            # do nothing
        end
      end
      
      break unless net.dig(by2 + y2, bx2 + x2)
      self.x, self.y = x2, y2
      if has_wrapped
        self.facing, @current_face, @bx, @by = facing2, face2, bx2, by2
        facing2 = facing!
      end
      
      $BB[@by+@y][@bx+@x] = 0
      
    end
    
    # $BB.each do|l|
    #   l.each do |c|
    #     print case c
    #       when nil then ' '
    #       when true then '.'
    #       when false then '#'
    #       else '+'
    #     end
    #   end
    #   puts
    # end
    # gets
    # puts "\e[H\e[2J"
    
  end
end

#XXX hard-coding
N, S, W, E =  Array.new(4) { CubeNetBoard::CubeFace.new }
U = CubeNetBoard::CubeFace.new([[E, 0], [S, 0], [W, 2], [N, 1]])
D = CubeNetBoard::CubeFace.new([[E, 2], [N, 1], [W, 0], [S, 0]])
N.neighbors = [[D, 3], [E, 0], [U, 3], [W, 0]]
S.neighbors = [[E, 3], [D, 0], [W, 3], [U, 0]]
W.neighbors = [[D, 0], [N, 0], [U, 2], [S, 1]]
E.neighbors = [[D, 2], [S, 1], [U, 0], [N, 0]]

puts(
  'Part 2',
  CubeNetBoard.call('input.txt') do|lines|
    CubeNetBoard.new(
      $BB = lines.map { _1.each_byte.map { |b| b <= 0x20 ? nil : b >= 0x28 } },
      # ` `.chr => 0x20, `#`.chr => 0x23
      { #XXX hard-coding
        U => [1, 0],
        D => [1, 2],
        N => [0, 3],
        S => [1, 1],
        W => [0, 2],
        E => [2, 0]
      },
      50
    )
  end
)
