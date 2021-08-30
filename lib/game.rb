# frozen_string_literal: true

require_relative 'tic_tac_toe'
require_relative 'input'
TicTacToe.new('x', 'o', %w[e exit]).start_game(Input.new)
