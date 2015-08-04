require_relative 'board'
require 'byebug'
require_relative 'pieces'
require_relative 'pawn'
require_relative 'king'
require_relative 'stepping_pieces'

class Chess
  attr_reader :white_player, :black_player
  attr_accessor :current_player, :board

  def initialize
    @white_player = HumanPlayer.new(:white)
    @black_player = HumanPlayer.new(:black)
    @board = Board.new
    @current_player = white_player
  end

  def play
    until game_over?
      begin
        board.render
        start_move, end_move = current_player.player_input
        board.move(start_move, end_move)
      rescue ArgumentError => e
        puts e.message
        retry
      end
      swap_players
    end

    board.render
    nil
  end

  def game_over?
    board.checkmate?(:white) || board.checkmate?(:black)
  end

  def swap_players
    current_player == white_player ? black_player : white_player
  end


end

class HumanPlayer
  attr_reader :color

  def initialize(color)
    @color = color
  end

  def player_input
    puts "#{color.to_s.capitalize}: Please input a starting position x y"
    start_pos = gets.chomp.split(" ").map! { |value| Integer(value) }
    puts "Please input an ending position x y"
    end_pos = gets.chomp.split(" ").map! { |value| Integer(value) }
    [start_pos, end_pos]
  end
end


c = Chess.new
b = c.board

k1 = King.new([3,3], :white, b)
k2 = King.new([2,2], :black, b)
c.play
