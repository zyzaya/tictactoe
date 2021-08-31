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
    let(:input) { instance_double('input') }
    let(:game_board) { [*1..9].map(&:to_s) }

    before do
      allow(tictactoe).to receive(:play_turn).and_return(true, true, false)
    end

    it 'calls play_turn' do
      player = tictactoe.first_player
      expect(tictactoe).to receive(:play_turn).with(game_board, player, input)
      tictactoe.run_game(game_board, input)
    end

    it 'calls play_turn three times when play_turn returns true twice and false once' do
      expect(tictactoe).to receive(:play_turn).exactly(3)
      tictactoe.run_game(game_board, input)
    end
  end

  describe '#play_turn' do
    let(:input) { instance_double('input') }
    let(:game_board) { [*1..9].map(&:to_s) }
    let(:player) { tictactoe.first_player }

    before do
      allow(tictactoe).to receive(:player_input)
      allow(tictactoe).to receive(:check_for_winner)
      allow(tictactoe).to receive(:next_player)
    end

    it 'prints values' do
      display = <<~BOARD

        #{game_board[6]} | #{game_board[7]} | #{game_board[8]}
        #{game_board[3]} | #{game_board[4]} | #{game_board[5]}
        #{game_board[0]} | #{game_board[1]} | #{game_board[2]}

      BOARD
      expect(tictactoe).to receive(:puts).with(display)
      tictactoe.play_turn(game_board, player, input)
    end

    it 'calls player_input' do
      available_cells = [1, 2, 3]
      allow(tictactoe).to receive(:available_cells).and_return(available_cells)
      expect(tictactoe).to receive(:player_input).with(player, available_cells, input)
      tictactoe.play_turn(game_board, player, input)
    end

    it 'returns false if cell is falsey' do
      cell = false
      allow(tictactoe).to receive(:player_input).and_return(cell)
      result = tictactoe.play_turn(game_board, player, input)
      expect(result).to be_falsey
    end

    it 'changes the board' do
      cell = 2
      allow(tictactoe).to receive(:player_input).and_return(cell)
      tictactoe.play_turn(game_board, player, input)
      expect(game_board[cell]).to eq(player)
    end

    it 'calls check_for_winner' do
      cell = 2
      allow(tictactoe).to receive(:player_input).and_return(cell)
      expect(tictactoe).to receive(:check_for_winner)
      tictactoe.play_turn(game_board, player, input)
    end

    it 'returns false if there is a winner' do
      cell = 2
      allow(tictactoe).to receive(:player_input).and_return(cell)
      allow(tictactoe).to receive(:check_for_winner).and_return(player)
      tictactoe.play_turn(game_board, player, input)
    end

    it 'calls next player' do
      cell = 2
      allow(tictactoe).to receive(:player_input).and_return(cell)
      expect(tictactoe).to receive(:next_player).with(player)
      tictactoe.play_turn(game_board, player, input)
    end
  end

  describe '#restart_game' do
    let(:input) { instance_double('input') }
    let(:winner) { tictactoe.first_player }

    it 'calls start_game if input is yes' do
      allow(input).to receive(:get_input).and_return('yes')
      expect(tictactoe).to receive(:start_game)
      tictactoe.restart_game(input, winner)
    end

    it 'does not call start_game if input is no' do
      allow(input).to receive(:get_input).and_return('no')
      expect(tictactoe).not_to receive(:start_game)
      tictactoe.restart_game(input, winner)
    end
  end

  describe '#board' do
    let(:display) do
      <<~BOARD

        #{game_board[6]} | #{game_board[7]} | #{game_board[8]}
        #{game_board[3]} | #{game_board[4]} | #{game_board[5]}
        #{game_board[0]} | #{game_board[1]} | #{game_board[2]}

      BOARD
    end

    let(:game_board) { [*1..9].map(&:to_s) }
    it 'returns a formatted string of an array of nine values' do
      result = tictactoe.board(game_board)
      expect(result).to eq(display)
    end
  end

  describe '#player_input' do
    let(:input) { instance_double('input') }
    let(:game_board) { [*1..9].map(&:to_s) }
    let(:player) { tictactoe.first_player }
    let(:valid) { %w[x o w n] }

    it 'calls get_input' do
      expect(input).to receive(:get_input)
      tictactoe.player_input(player, valid, input)
    end

    it 'returns the integer of the given input minus one' do
      given = '10'
      allow(input).to receive(:get_input).and_return(given)
      result = tictactoe.player_input(player, valid, input)
      expect(result).to eql(9)
    end

    it 'returns false if exit code is given' do
      given = 'e'
      allow(input).to receive(:get_input).and_return(given)
      result = tictactoe.player_input(player, valid, input)
      expect(result).to be_falsey
    end
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
