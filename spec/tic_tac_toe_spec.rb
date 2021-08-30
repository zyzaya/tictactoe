# frozen_string_literal: true

require 'tic_tac_toe'

describe TicTacToe do
  subject(:tictactoe) { described_class.new('x', 'o', %w[e exit]) }

  describe '#start_game' do
    let(:input) { instance_double('input') }
    let(:game_board) { [*1..9].map(&:to_s) }

    before do
      allow(tictactoe).to receive(:generate_empty_board).and_return(game_board)
      allow(tictactoe).to receive(:run_game)
      allow(tictactoe).to receive(:check_for_winner)
      allow(tictactoe).to receive(:restart_game)
    end

    it 'generates an empty board' do
      expect(tictactoe).to receive(:generate_empty_board).and_return(game_board)
      tictactoe.start_game(input)
    end

    it 'calls run_game with an empty board and input' do
      expect(tictactoe).to receive(:run_game).with(game_board, input)
      tictactoe.start_game(input)
    end

    it 'calls check_for_winner with board values' do
      expect(tictactoe).to receive(:check_for_winner).with(game_board)
      tictactoe.start_game(input)
    end

    it 'calls check_for_winner if there is a winner' do
      allow(tictactoe).to receive(:check_for_winner).and_return(true)
      expect(tictactoe).to receive(:restart_game).with(input, true)
      tictactoe.start_game(input)
    end

    it 'does not call check_for_winner if there is no winner' do
      allow(tictactoe).to receive(:check_for_winner).and_return(false)
      expect(tictactoe).not_to receive(:restart_game)
      tictactoe.start_game(input)
    end
  end

  describe '#run_game' do
    # loop runs while continue returns true
    # loop ends when continue returns false
  end

  describe '#play_turn' do
    # prints values
    # calls player input
    # changes the board
    # calls check_for_winner
    # calls next_player
    # returns false if the game should not continue
    #   player input is nil - meaning no input was given
    #   winner is true - a player has won
  end

  describe '#restart_game' do
    # calls start_game if input is yes
    # if input is not yes does not call start_game.
  end

  describe '#board' do
    # returns a formatted string of an array of 9 values
  end

  describe '#player_input' do
    # calls input.get_input
    # it returns the integer of the cell - 1
    # it returns false if no input is given/the exit code is given
  end

  describe '#available_cells' do
    # it returns an array of cells that are not marked with player icons
  end

  describe '#check_for_winner' do
    # returns the character of the winner if there is one
    # returns false if there is no winner
  end

  describe '#next_player' do
    # returns first player if current is second player
    # returns second player if current is first player
  end

  describe '#generate_board' do
    # returns an array of the numbers 1 to 9 (as strings)
  end
end