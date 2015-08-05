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
    self[pos] && self[pos].color == color
  end

  def has_opponent_piece?(pos,color)
    has_piece?(pos) && !has_color_piece?(pos,color)
  end

  def render
    display_grid = grid.transpose.reverse
    display_grid.each_with_index do |row, row_number|
        print "#{8-row_number}"
      row.each do |element|
        if element
          print " #{element.to_s} "
        else
          print " _ "
        end
      end
      puts
    end
    puts "  A  B  C  D  E  F  G  H"
    nil
  end



  def move(start, end_pos)
    piece = self[start]
    raise ArgumentError.new("Error: No piece at start") if piece.nil?

    if piece.move_into_check?(end_pos)
      raise ArgumentError.new("Error: Moving into check!")
    end

    unless piece.moves.include?(end_pos)
      raise ArgumentError.new("Error: Piece cannot move to end position")
    end

    move!(start, end_pos)
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
