require_relative 'pieces'

class Board
  BOARD_LENGTH = 8
  attr_reader :grid
  #ROOK_POSITIONS = []

  def self.dup(board)
    new_board = Board.new

    board.grid.each_with_index do |row, row_number|
      row.each_with_index do |element, column_number|
        if element
          new_element = element.dup
          new_element.board = new_board
          new_board[[row_number,column_number]] = new_element
        end
      end
    end

    new_board
  end

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
    display_grid.each_with_index do |row, row_number|
        print "#{7-row_number}"
      row.each do |element|
        if element
          print " #{element.to_s} "
        else
          print " _ "
        end
      end
      puts
    end
    puts "  0  1  2  3  4  5  6  7"
    nil
  end



  def move(start, end_pos)
    piece = self[start]

    if piece.move_into_check?(end_pos)
      raise ArgumentError.new("Moving into check!")
    end

    raise ArgumentError.new("No piece at start") if piece.nil?
    unless piece.moves.include?(end_pos)
      raise ArgumentError.new("Piece cannot move to end position")
    end

    piece.position = end_pos
    self[start] = nil
    self[end_pos] = piece
  end

  def move!(start, end_pos)
    piece = self[start]
    piece.position = end_pos
    self[start] = nil
    self[end_pos] = piece
  end

  def checkmate?(color)
    return false unless in_check?(color)

    current_pieces = grid.flatten.compact.select {|piece| piece.color == color }

    current_pieces.all? {|piece| piece.valid_moves.empty? }
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
