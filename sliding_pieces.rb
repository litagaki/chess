require_relative 'pieces'
require 'byebug'

class SlidingPiece < Piece

  def moves
    valid_moves = []
    x,y = position

    self.class::DELTAS.each do |(dx,dy)|
      distance = 1
      new_pos = [x + dx * distance, y + dy * distance]

      until new_pos && !board.on_board?(new_pos)

        break if board.has_color_piece?(new_pos, color)
        valid_moves << new_pos

        if board.has_piece?(new_pos) && !board.has_color_piece?(new_pos, color)
            break
        end

        distance += 1
        new_pos = [x + dx * distance, y + dy * distance]
      end
    end

    valid_moves
  end
end
