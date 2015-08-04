require_relative 'pieces'
require 'byebug'

class Pawn < Piece

  def initialize(position, color, board)
    super(position, color, board)
    @has_moved = false
  end

  def has_moved?
    @has_moved
  end

  def valid_forward_move?(pos)
    board.on_board?(pos) && !board.has_piece?(pos)
  end

  def position=(pos)
    @position = pos
    @has_moved = true
  end

  def moves
    valid_moves = []
    dy = color == :white ? 1 : -1
    x,y = position

    next_pos = [x, y + dy]
    if valid_forward_move?(next_pos)
      valid_moves << next_pos
      next_pos = [x, y + dy * 2]
      if valid_forward_move?(next_pos) && !has_moved?
        valid_moves << next_pos
      end
    end

    #If enemy piece on forward diagonal, can capture


    valid_moves
  end

  def to_s
    "p"
  end
end
