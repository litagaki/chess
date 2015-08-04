require_relative 'sliding_pieces'
require 'byebug'

class Queen < SlidingPiece
  DELTAS = ORTHOGONAL_DELTAS + DIAGONAL_DELTAS

  def to_s
    "Q"
  end

end
