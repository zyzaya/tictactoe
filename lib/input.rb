# frozen_string_literal: true

class Input
  def get_input(info, retry_text, valid_input)
    # input should accept exit_code as parameter
    # downcasing valid input should be its own method
    puts info
    valid_input = downcase_valid_input(valid_input)

    valid = false
    until valid
      input = gets.chomp.downcase
      valid = valid_input.include?(input)
      puts retry_text unless valid
    end
    input
  end

  def downcase_valid_input(valid_input)
    valid_input.map(&:downcase)
  end
end
