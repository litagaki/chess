require_relative 'sliding_pieces'
require 'byebug'

class Rook < SlidingPiece
  DELTAS = ORTHOGONAL_DELTAS

  def to_s
    "R"
  end

end
