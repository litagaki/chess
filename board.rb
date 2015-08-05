require 'colorize'

class Board
  BOARD_LENGTH = 8
  attr_reader :grid

  VIP_COLUMNS = [
    "Rook",
    "Knight",
    "Bishop",
    "Queen",
    "King",
    "Bishop",
    "Knight",
    "Rook"
  ]
  ROOK_COLUMNS = [0, 7]
  VIP_ROWS = {
    :white => 0,
    :black => 7
    }
  PAWN_ROWS = {
    :white => 1,
    :black => 6
    }

  def self.on_board?(pos)
    pos.all? { |coordinate| coordinate.between?(0, BOARD_LENGTH - 1) }
  end

  def initialize
    @grid = Array.new(BOARD_LENGTH) { Array.new(BOARD_LENGTH) }
  end

  def populate_board
    VIP_ROWS.each do |color, y|
      VIP_COLUMNS.each_with_index do |piece_type, x|
        Object.const_get(piece_type).new([x,y],color,self)
      end
    end

    PAWN_ROWS.each do |color, y|
      (0...BOARD_LENGTH).each do |x|
        Pawn.new([x,y],color,self)
      end
    end

    self
  end

  def dup
    new_board = Board.new

    pieces_list.each do |piece|
      piece.class.new(piece.position, piece.color, new_board)
    end

    new_board
  end

  def [](pos)
    x,y = pos
    grid[x][y]
  end

  def []=(pos, value)
    x,y = pos
    grid[x][y] = value
  end

  def has_piece?(pos)
    self[pos]
  end

  def has_color_piece?(pos, color)
    has_piece?(pos) && self[pos].color == color
  end

  def has_opponent_piece?(pos,color)
    has_piece?(pos) && self[pos].color != color
  end

  def render
    display_grid = grid.transpose.reverse

    display_grid.each_with_index do |row, row_number|
        print "#{8-row_number}"
      row.each_with_index do |element,col_number|
        row_col_sum = row_number + col_number
        if element
          print " #{element.to_s} ".tileize(row_col_sum)
        else
          print "   ".tileize(row_col_sum)
        end
      end
      puts
    end
    puts "  A  B  C  D  E  F  G  H"
    nil
  end

  def move(start, end_pos)
    piece = self[start]
    raise ChessError.new("Error: No piece at start") if piece.nil?

    if piece.move_into_check?(end_pos)
      raise ChessError.new("Error: Moving into check!")
    end

    unless piece.moves.include?(end_pos)
      raise ChessError.new("Error: Piece cannot move to end position")
    end

    move!(start, end_pos)
  end

  def move!(start, end_pos)
    piece = self[start]
    piece.position = end_pos
    self[start] = nil
    self[end_pos] = piece
  end

  def castle_move(rook_pos)
    rook_x, y = rook_pos
    king_x = 4
    if rook_x == 0
      new_rook_x = 3
      new_king_x = 2
    elsif rook_x ==7
      new_rook_x = 5
      new_king_x = 6
    else
      raise ChessError.new("Rook not in suitable castling position")
    end
    move!([rook_x,y],[new_rook_x,y]) #Move rook
    move!([king_x,y],[new_king_x,y]) #Move king
  end

  def checkmate?(color)
    return false unless in_check?(color)

    current_pieces = pieces_list.select {|piece| piece.color == color }

    current_pieces.all? {|piece| piece.valid_moves.empty? }
  end

  def stalemate?(color)
    return false if in_check?(color)

    current_pieces = pieces_list.select {|piece| piece.color == color }

    current_pieces.all? {|piece| piece.valid_moves.empty? }
  end


  def king(color)
    king = pieces_list.find do |element|
      element.class == King && element.color == color
    end
  end

  def in_check?(color)
    king_pos = king(color).position

    pieces_list.each do |element|
      return true if element.color != color && element.moves.include?(king_pos)
    end

    false
  end

  def upgradable_pawn?
    VIP_ROWS.values.any? do |row|
      (0...BOARD_LENGTH).any? do |column|
        self[[column, row]].class == Pawn
      end
    end
  end


  # VIP_ROWS = {
  #   :white => 0,
  #   :black => 7
  #   }

  #king.move_into_check?(end_pos)

  def castleable_rook_pos(color)

    rook_positions = []

    king = king(color)

    #look in original rook positions
    rook1 = self[[ ROOK_COLUMNS[0],VIP_ROWS[color] ]]
    rook2 = self[[ ROOK_COLUMNS[1],VIP_ROWS[color] ]]

    unless king.has_moved? || in_check?(color) #checks to see if king has moved
      if rook1.class == Rook && !rook1.has_moved?
        castleable = true
        castleable = false if self[[ 1,VIP_ROWS[color] ]]
        castleable = false if !is_safe_king_place?(king,2,color)
        castleable = false if !is_safe_king_place?(king,3,color)
        rook_positions << rook1.position if castleable
      end
      if rook2.class == Rook && !rook2.has_moved?
        castleable = true
        castleable = false if !is_safe_king_place?(king,5,color)
        castleable = false if !is_safe_king_place?(king,6,color)
        rook_positions << rook2.position if castleable
      end
    end


    rook_positions
  end

  private

  def is_safe_king_place?(king_piece,x_pos,color)
    return !( self[[ x_pos,VIP_ROWS[color] ]] ||
       king_piece.move_into_check?([x_pos,VIP_ROWS[color] ] ) )
  end

  def pieces_list
    grid.flatten.compact
  end

end

class ChessError < StandardError
end

class String
  def tileize(sum)
    if sum % 2 == 0
      self.colorize( :background => :white )
    else
      self.colorize( :background => :light_white )
    end
  end
end
