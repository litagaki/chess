# chess
This Ruby program lets you and a friend play chess in the terminal. Simply download the entire repo, install the colorize gem if necessary, and then use Ruby to run chess.rb.

Determining whether a move would put a player in check required doing a deep dup of the board, executing the move, and then assessing the check status.
Piece#move_into_check?

-TO DO
implement en passant pawn capture
