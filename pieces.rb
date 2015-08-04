require 'byebug'
require_relative 'board'

class Piece
  attr_accessor :board, :position
  attr_reader :color

  def initialize(position, color, board)
    @position = position
    @color = color
    @board = board
    board[position] = self
  end

  def moves
    raise NotImplementedError
  end

  def move_into_check?(new_pos)
    temp_board = Board.dup(board)
    temp_board.move(position,new_pos)

    temp_board.in_check?(color)
  end

  def valid_moves
    moves.reject {|move| move_into_check?(move) }
  end

  def inspect
    {
      :postion => position,
      :color => color,
      :type => self.class
    }.inspect
  end

end
