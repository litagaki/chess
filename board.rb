require_relative 'pieces'

class Board
  BOARD_LENGTH = 8
  attr_reader :grid

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

  def has_color_piece?(pos, color)
    self[pos].color == color
  end
end
