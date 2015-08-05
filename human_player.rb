class HumanPlayer
  attr_reader :color

  def initialize(color)
    @color = color
  end

  def castling_input(castle_options)
    if castle_options.size == 1
      puts "You can castle with your Rook and King."
      puts "Enter Y if you'd like to, otherwise press any key"
      response = gets.chomp.upcase
      return 1 if response == "Y"
    elsif castle_options.size == 2
      puts "You can castle with both rooks."
      puts "Enter L for left castle, R for right castle, otherwise press any key"
      response = gets.chomp.upcase
      return 1 if response == "L"
      return 2 if response == "R"
    end
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
