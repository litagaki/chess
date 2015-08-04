require_relative 'pieces'
require_relative 'stepping_pieces'
require_relative 'board'

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
end
