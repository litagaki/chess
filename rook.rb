require 'sliding_pieces'
require 'byebug'

class Rook < SlidingPiece
  DELTAS = [
    [ 1, 0],
    [-1, 0],
    [ 0,-1],
    [ 0, 1]
  ]

  def to_s
    "R"
  end
  
end
