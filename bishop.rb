require_relative 'sliding_pieces'
require 'byebug'

class Bishop < SlidingPiece
  DELTAS = [
    [ 1,  1],
    [-1, -1],
    [ 1, -1],
    [-1,  1]
  ]

  def to_s
    "B"
  end

end
