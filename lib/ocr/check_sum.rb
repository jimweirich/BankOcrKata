module OCR
  class CheckSum
    def check?(digit_string)
      check_sum(digit_string) == 0
    end

    def check_sum(digit_string)
      sum(digit_string) % 11
    end

    private

    def sum(digit_string)
      chars = digit_string.chars
      multipliers = (1..digit_string.size).to_a.reverse
      chars.zip(multipliers).inject(0) { |sum, (c,n)| c.to_i * n + sum }
    end
  end
end
