# frozen_string_literal: true

require_relative 'input'

# Allows for a command line game of TicTacToe
class TicTacToe
  attr_reader :first_player, :second_player
  
  WIN_VALUES = [
    [0, 1, 2], [3, 4, 5], [6, 7, 8],
    [0, 3, 6], [1, 4, 7], [2, 5, 8],
    [0, 4, 8], [2, 4, 6]
  ].freeze

  def initialize(first_player, second_player, exit_code)
    @first_player = first_player
    @second_player = second_player
    @exit_code = exit_code
  end

  def start_game(input)
    values = generate_empty_board
    run_game(values, input)
    winner = check_for_winner(values)
    restart_game(input, winner) if winner
  end

  def run_game(values, input)
    current_player = @first_player
    current_player = play_turn(values, current_player, input) while current_player
  end

  def restart_game(input, winner)
    retry_text = 'Invalid input. Please enter "yes" or "no"'
    yes_input = %w[y yes]
    no_input = %w[n no]
    again = input.get_input("#{winner} wins! Play again? (y/n)", retry_text, yes_input + no_input)
    start_game(input) if yes_input.include?(again)
  end

  def play_turn(values, current_player, input)
    puts board(values)
    cell = player_input(current_player, available_cells(values + @exit_code), input)
    return false unless cell

    values[cell] = current_player
    winner = check_for_winner(values)
    return false if winner

    next_player(current_player)
  end

  def next_player(current)
    return @first_player if current == @second_player
    return @second_player if current == @first_player
  end

  def available_cells(board)
    board.reject { |v| [@first_player, @second_player].include?(v.downcase) }
  end

  def board(values)
    <<~BOARD

      #{values[6]} | #{values[7]} | #{values[8]}
      #{values[3]} | #{values[4]} | #{values[5]}
      #{values[0]} | #{values[1]} | #{values[2]}

    BOARD
  end

  def player_input(player, valid_input, input)
    retry_text = 'Invalid input. Please select an available cell.'
    cell = input.get_input("#{player}'s turn.", retry_text, valid_input)
    return false if @exit_code.include?(cell)

    cell.to_i - 1
  end

  def check_for_winner(board)
    winner = false
    WIN_VALUES.each do |w|
      if w.all? { |v| board[v] == @first_player }
        winner = @first_player
      elsif w.all? { |v| board[v] == @second_player }
        winner = @second_player
      end
      break if winner
    end
    winner
  end

  def generate_empty_board
    [*1..9].map(&:to_s)
  end
end
