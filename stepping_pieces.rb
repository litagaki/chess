class SteppingPiece < Piece
  def moves
    valid_moves = []
    x,y = position

    self.class::DELTAS.each do |(dx, dy)|
      new_pos = [x + dx, y + dy]
      if Board.on_board?(new_pos) && !board.has_color_piece?(new_pos, color)
        valid_moves << new_pos
      end
    end

    valid_moves
  end
end
