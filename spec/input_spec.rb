require 'input'

describe Input do
  describe '#get_input' do
    subject(:input) { Input.new }

    context 'when input is valid' do
      info = 'Enter "one" or "two"'
      retry_text = 'Bad input. Enter "one" or "two"'
      valid_input = ['one', 'two']
      given_input = valid_input[1]

      before do
        allow(input).to  receive(:gets).and_return(given_input)
      end

      it 'prints info' do
        expect(input).to receive(:puts).with(info)
        input.get_input(info, retry_text, valid_input)
      end

      it 'returns the given input' do
        expect(input).not_to receive(:puts).with(retry_text)
        result = input.get_input(info, retry_text, valid_input)
        expect(result).to eq(given_input)
      end

      it 'ignores case' do
        allow(input).to  receive(:gets).and_return(given_input.upcase)
        expect(input).not_to receive(:puts).with(retry_text)
        result = input.get_input(info, retry_text, valid_input)
        expect(result).to eq(given_input)
      end
    end

    context 'when input is not valid' do
      info = 'Enter "one" or "two"'
      retry_text = 'Bad input. Enter "one" or "two"'
      valid_input = ['one', 'two']
      first_input = 'this is not "one" or "two"'
      second_input = 'one'

      before do
        allow(input).to  receive(:gets).and_return(first_input, second_input)
      end

      it 'prints info, then retry_text' do
        expect(input).to receive(:puts).with(info).once
        expect(input).to receive(:puts).with(retry_text)
        input.get_input(info, retry_text, valid_input)
      end
    end
  end

  describe '#downcase_valid_input' do
    subject(:input) { Input.new }

    context 'when the array is empty' do
      it 'returns an empty array' do
        valid_input = []
        result = input.downcase_valid_input(valid_input)
        expect(result).to eq([])
      end
    end

    context 'when the array contains elements' do
      it 'returns an array with all elements downcased' do
        valid_input = ['First', 'SeCoND', 'Third', 'fourth']
        downcased_input = ['first', 'second', 'third', 'fourth']
        result = input.downcase_valid_input(valid_input)
        expect(result).to eql(downcased_input)
      end
    end
  end
end