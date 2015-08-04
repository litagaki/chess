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
    "N"
  end
end
