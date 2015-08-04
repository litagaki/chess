require_relative 'pieces'

class Board
  BOARD_LENGTH = 8
  attr_reader :grid
  #ROOK_POSITIONS = []


  def initialize
    @grid = Array.new(BOARD_LENGTH) { Array.new(BOARD_LENGTH) }
    #populate board
  end

  def [](pos)
    x,y = pos
    grid[x][y]
  end

  def []=(pos, value)
    x,y = pos
    grid[x][y] = value
  end

  def on_board?(pos)
    pos.all? { |coordinate| coordinate.between?(0, BOARD_LENGTH - 1) }
  end

  def has_piece?(pos)
    self[pos]
  end

  def has_color_piece?(pos, color)
    self[pos] ? self[pos].color == color : false
  end

  def has_opponent_piece?(pos,color)
    has_piece?(pos) && !has_color_piece?(pos,color)
  end

  def render
    display_grid = grid.transpose.reverse
    display_grid.each do |row|
      row.each do |element|
        if element
          print " #{element.to_s} "
        else
          print " _ "
        end
      end
      puts
    end
    nil
  end

end
