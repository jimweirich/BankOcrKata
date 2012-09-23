module OCR

  class Recognizer
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

    SCANNABLE_CHARS = ('0'..'9').map { |n| FROM_DIGIT[n].join }

    class Guess < Struct.new(:confidence, :char, :scanned_char)
      include Comparable

      def initialize(original, guessed)
        super(diff(original, guessed), TO_DIGIT[guessed], guessed)
      end

      def <=>(other)
        (confidence <=> other.confidence).nonzero? || (char <=> other.char)
      end

      private

      def diff(a, b)
        a.chars.zip(b.chars).map { |a, b| a == b }.count(false)
      end
    end

    def recognize(scanned_char)
      TO_DIGIT[scanned_char] || "?"
    end

    def guess(scanned_char, confidence=10)
      guess_all(scanned_char).select { |guess| guess.confidence <= confidence }
    end

    private

    def guess_all(scanned_char)
      SCANNABLE_CHARS.map { |sc|
        Guess.new(scanned_char, sc)
      }.sort
    end
  end

end
