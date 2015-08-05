require_relative 'board'
require 'byebug'
require_relative 'pieces'
require_relative 'pawn'
require_relative 'king'
require_relative 'stepping_pieces'
require_relative 'bishop'
require_relative 'knight'
require_relative 'queen'
require_relative 'sliding_pieces'
require_relative 'rook'

class Chess
  attr_reader :white_player, :black_player
  attr_accessor :current_player, :board

  def initialize
    @white_player = HumanPlayer.new(:white)
    @black_player = HumanPlayer.new(:black)
    @board = Board.new
    board.populate_board
    @current_player = white_player
  end

  def play
    until game_over?
      begin
        board.render
        start_move, end_move = current_player.player_input
        check_valid_piece(start_move)
        board.move(start_move, end_move)
     rescue StandardError => e
       puts e.message
       retry
     end
      swap_players
    end

    board.render
    nil
  end

  def check_valid_piece(start_pos)
    if !board.has_piece?(start_pos)
      raise ArgumentError.new("Error: no piece present!")
    elsif board.has_opponent_piece?(start_pos, current_player.color)
      raise ArgumentError.new("Error: not your piece!")
    end
  end

  def game_over?
    board.checkmate?(:white) || board.checkmate?(:black)
  end

  def swap_players
    if current_player == white_player
      self.current_player = black_player
    else
      self.current_player = white_player
    end
  end

end

class HumanPlayer
  attr_reader :color

  def initialize(color)
    @color = color
  end

  def player_input
    begin
      puts "#{color.to_s.capitalize}: Please input a starting position (Ex: f8)"
      start_pos = input_to_position(gets.chomp)
    rescue
      puts "Invalid input -- Give valid board position (Ex: a6)"
      retry
    end
    begin
      puts "Please input an ending position (Ex: f9)"
      end_pos = input_to_position(gets.chomp)
    rescue
      puts "Invalid input -- Give valid board position (Ex: a6)"
      retry
    end
    [start_pos, end_pos]
  end

  def input_to_position(input)
    raise ArgumentError if input.empty? || input.length > 2
    x, y = input.split("")
    x = x.downcase.ord - 97
    raise ArgumentError unless x.between?(0,Board::BOARD_LENGTH - 1)
    raise ArgumentError if y.nil?

    y = Integer(y) - 1
    raise ArgumentError unless y.between?(0,Board::BOARD_LENGTH - 1)

    [x,y]
  end
end


c = Chess.new
b = c.board

c.play
