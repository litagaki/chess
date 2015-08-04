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

  def move(start, end_pos)
    piece = self[start]
    raise ArgumentError.new("No piece at start") if piece.nil?
    unless piece.moves.include?(end_pos)
      raise ArgumentError.new("Piece cannot move to end position")
    end

    piece.position = end_pos
    self[start] = nil
    self[end_pos] = piece
  end

  def in_check?(color)
    king = grid.flatten.select do |element|
      element.class == King && element.color == color
    end

    king_pos = king.first.position
    grid.flatten.compact.each do |element|
      return true if element.color != color && element.moves.include?(king_pos)
    end
    false
  end

end
