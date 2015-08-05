class Pawn < Piece
  DELTA_X = [-1, 1]

  def initialize(position, color, board)
    super(position, color, board)
    @has_moved = false
    @dy = color == :white ? 1 : -1
  end

  def has_moved?
    @has_moved
  end

  def position=(pos)
    @position = pos
    @has_moved = true
  end

  def moves
    valid_moves = forward_moves + diagonal_moves
  end

  def to_s
    color == :white ? "\u2659" : "\u265F"
  end

  private
    attr_reader :dy

    def valid_forward_move?(pos)
      Board.on_board?(pos) && !board.has_piece?(pos)
    end

    def diagonal_moves
      valid_diagonal_moves = []
      x,y = position

      DELTA_X.each do |dx|
        next_pos = [x + dx, y + dy]
        if Board.on_board?(next_pos) && board.has_opponent_piece?(next_pos,color)
          valid_diagonal_moves << next_pos
        end
      end

      valid_diagonal_moves
    end

    def forward_moves
      x,y = position
      valid_forward_moves = []

      next_pos = [x, y + dy]
      if valid_forward_move?(next_pos)
        valid_forward_moves << next_pos
        next_pos = [x, y + dy * 2]
        if valid_forward_move?(next_pos) && !has_moved?
          valid_forward_moves << next_pos
        end
      end

      valid_forward_moves
    end

end
