require_relative 'sliding_pieces'
require 'byebug'

class Bishop < SlidingPiece
  DELTAS = DIAGONAL_DELTAS

  def to_s
    color == :white ? "\u2657" : "\u265D"
  end

end
