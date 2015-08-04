require_relative 'sliding_pieces'
require 'byebug'

class Queen < SlidingPiece
  DELTAS = [
    [ 1,  1],
    [-1, -1],
    [ 1, -1],
    [-1,  1],
    [ 1,  0],
    [-1,  0],
    [ 0, -1],
    [ 0,  1]
  ]

  def to_s
    "Q"
  end

end
