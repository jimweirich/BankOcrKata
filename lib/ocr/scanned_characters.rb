module OCR
  module ScannedCharacters
    TO_DIGIT = {
      " _ " +
      "| |" +
      "|_|" => "0",

      "   " +
      "  |" +
      "  |" => "1",

      " _ " +
      " _|" +
      "|_ " => "2",

      " _ " +
      " _|" +
      " _|" => "3",

      "   " +
      "|_|" +
      "  |" => "4",

      " _ " +
      "|_ " +
      " _|" => "5",

      " _ " +
      "|_ " +
      "|_|" => "6",

      " _ " +
      "  |" +
      "  |" => "7",

      " _ " +
      "|_|" +
      "|_|" => "8",

      " _ " +
      "|_|" +
      " _|" => "9",
    }

    def self.by_width(string)
      string.scan(/.../)
    end

    def self.reverse_lookup(to_digit)
      to_digit.inject({}) { |h, (k,v)| h.merge(v => by_width(k)) }
    end

    FROM_DIGIT = reverse_lookup(TO_DIGIT)
  end
end
