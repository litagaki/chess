require_relative 'pieces'
require 'byebug'

class SlidingPiece < Piece
  ORTHOGONAL_DELTAS = [
    [ 1, 0],
    [-1, 0],
    [ 0,-1],
    [ 0, 1]
  ]
  DIAGONAL_DELTAS = [
    [ 1,  1],
    [-1, -1],
    [ 1, -1],
    [-1,  1]
  ]



  def moves
    valid_moves = []
    x,y = position

    self.class::DELTAS.each do |(dx,dy)|
      distance = 1
      new_pos = [x + dx * distance, y + dy * distance]

      until new_pos && !board.on_board?(new_pos)
        break if board.has_color_piece?(new_pos, color)
        valid_moves << new_pos
        break if board.has_opponent_piece?(new_pos,color)

        distance += 1
        new_pos = [x + dx * distance, y + dy * distance]
      end
    end

    valid_moves
  end
end
