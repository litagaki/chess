require_relative 'stepping_pieces'

class King < SteppingPiece
  DELTAS = [
    [-1, -1],
    [-1,  0],
    [-1,  1],
    [ 0,  1],
    [ 0, -1],
    [ 1, -1],
    [ 1,  0],
    [ 1,  1]
  ]

  def to_s
    color == :white ? "\u2654" : "\u265A"
  end

end
