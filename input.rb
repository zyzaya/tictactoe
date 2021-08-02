# frozen_string_literal: true

class Input
  attr_reader :exit_code

  def initialize(exit_code)
    @exit_code = exit_code
  end

  def get_input(info, retry_text, valid_input)
    puts info
    valid_input = (valid_input + @exit_code).map(&:downcase)

    valid = false
    until valid
      input = gets.chomp.downcase
      valid = valid_input.include?(input)
      puts retry_text unless valid
    end
    input
  end
end
