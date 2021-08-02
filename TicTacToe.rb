require_relative 'Input.rb'

class TicTacToe
  X = 'x'
  O = 'o'
  YES_INPUT = ['y', 'yes']
  NO_INPUT = ['n', 'no']
  INVALID_INPUT = 'Invalid input. Please try again.'
  WIN_VALUES = [
    [0, 1, 2], [3, 4, 5], [6, 7, 8],
    [0, 3, 6], [1, 4, 7], [2, 5, 8],
    [0, 4, 8], [2, 4, 6]
  ]
  EXIT_INPUT = ['exit', 'e']

  def initialize
    reset_game
    @input = Input.new(EXIT_INPUT)
    @values = []
  end

  def start_game
    reset_game
    winner = false
    quit = false
    until winner || quit
      puts get_board
      break unless play_turn(X)
      puts get_board
      winner = check_for_winner
      unless winner 
        break unless play_turn(O)
        winner = check_for_winner
      end
    end
    again = @input.get_input("#{winner} wins! Play again? (y/n)", INVALID_INPUT, YES_INPUT + NO_INPUT)
    start_game if YES_INPUT.include?(again)
  end
  
  def get_board
    <<~board 
      
      #{@values[6]} | #{@values[7]} | #{@values[8]}
      #{@values[3]} | #{@values[4]} | #{@values[5]}
      #{@values[0]} | #{@values[1]} | #{@values[2]}

    board
  end

  private
  def play_turn(player)
    valid_input = @values.select do |v|
      v.downcase != X && v.downcase != O
    end
    cell = @input.get_input("#{player}'s turn.", INVALID_INPUT, valid_input)
    return false if @input.exit_code.include?(cell)
    @values[cell.to_i - 1] = player
  end

  def check_for_winner
    winner = false
    WIN_VALUES.each {|w|
      winner = X if w.all? {|v| @values[v] == X}
      winner = O if !winner && w.all? {|v| @values[v] == O}
      break if winner
    }
    winner
  end
  
  def reset_game
    @values = [*1..9].map {|v| v.to_s}
  end
end

TicTacToe.new.start_game