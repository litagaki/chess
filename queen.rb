class Queen < SlidingPiece
  DELTAS = ORTHOGONAL_DELTAS + DIAGONAL_DELTAS

  def to_s
    color == :white ? "\u2655" : "\u265B"
  end

end
