require_relative 'sliding_pieces'
require 'byebug'

class Bishop < SlidingPiece
  DELTAS = DIAGONAL_DELTAS

  def to_s
    "B"
  end

end
