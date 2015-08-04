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

  def inspect
    {
      :postion => position,
      :color => color,
      :type => self.class
    }.inspect
  end

end
