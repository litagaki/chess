require 'byebug'
require 'yaml'
require 'colorize'

require_relative 'board'
require_relative 'pieces'
require_relative 'pawn'
require_relative 'stepping_pieces'
require_relative 'king'
require_relative 'knight'
require_relative 'sliding_pieces'
require_relative 'queen'
require_relative 'rook'
require_relative 'bishop'

class Chess
  attr_reader :white_player, :black_player
  attr_accessor :current_player, :board, :file_name
  attr_writer :saving

  def initialize
    @white_player = HumanPlayer.new(:white)
    @black_player = HumanPlayer.new(:black)
    @board = Board.new
    board.populate_board
    @current_player = white_player
  end

  def save_file
    puts "What do you want to name your file?"
    self.file_name = gets.chomp
    saved_game = self.to_yaml
    File.open(file_name, 'w') {|f| f << saved_game}
  end

  def auto_save
    saved_game = self.to_yaml
    File.open(file_name, 'w') {|f| f << saved_game}
  end

  def load_file
    puts "What is the name of the file you want to load?"
    self.file_name = gets.chomp
    input_data = File.read(file_name)
    loaded_game = YAML::load(input_data)
    self.board = loaded_game.board
    self.current_player = loaded_game.current_player
  end

  def save_request
    puts "To save your game as you go press S, otherwise press any key "
    response = gets.chomp.upcase
    if response == "S"
      self.saving = true
      save_file
    end
  end

  def load_request
    begin
      puts "To load saved game press L, otherwise press any key"
      response = gets.chomp.upcase
      if response == "L"
        self.saving = true
        load_file
      end
    rescue IOError => e
      puts e.message
      retry
    end
  end

  def play
    load_request
    save_request unless saving?
    until game_over?
      begin
        board.render
        start_move, end_move = current_player.player_input
        check_piece_ownership(start_move)
        board.move(start_move, end_move)
     rescue ChessError => e
       puts e.message
       retry
     end
      swap_players
      auto_save if saving?
    end

    puts "GAME OVER: #{current_player.color} won!"
    board.render
    nil
  end

  def check_piece_ownership(start_pos)
    if board.has_opponent_piece?(start_pos, current_player.color)
      raise ChessError.new("Error: not your piece!")
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

  private

  def saving?
    @saving
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
    rescue ChessError
      puts "Invalid input -- Give valid board position (Ex: a6)"
      retry
    end

    begin
      puts "Please input an ending position (Ex: f9)"
      end_pos = input_to_position(gets.chomp)
    rescue ChessError
      puts "Invalid input -- Give valid board position (Ex: a6)"
      retry
    end

    [start_pos, end_pos]
  end

  def input_to_position(input)
    raise ChessError unless input.length == 2
    x, y = input.split("")
    x = x.downcase.ord - 97

    y = Integer(y) - 1
    raise ChessError unless Board.on_board?([x,y])

    [x,y]
  end
end


c = Chess.new
b = c.board

c.play
