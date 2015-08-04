require_relative 'pieces'
require_relative 'stepping_pieces'
require_relative 'board'

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
end
