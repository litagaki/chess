require_relative 'stepping_pieces'

class Knight < SteppingPiece
  DELTAS = [
    [-2, -1],
    [-2,  1],
    [ 2,  1],
    [ 2, -1],
    [ 1, -2],
    [ 1,  2],
    [-1,  2],
    [-1, -2]
  ]

  def to_s
    color == :white ? "\u2658" : "\u265E"
  end
end
