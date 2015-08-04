require_relative 'sliding_pieces'
require 'byebug'

class Rook < SlidingPiece
  DELTAS = ORTHOGONAL_DELTAS

  def to_s
    color == :white ? "\u2656" : "\u265C"
  end

end
