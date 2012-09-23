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

    class Guess < Struct.new(:confidence, :guessed_char, :guessed_scan, :original_char)
      include Comparable

      def initialize(original, guessed)
        super(diff(original, guessed), TO_DIGIT[guessed], guessed, original)
      end

      def <=>(other)
        (confidence <=> other.confidence).nonzero? || (guessed_char <=> other.guessed_char)
      end

      def to_s
        "Guess(#{guessed_char})"
      end

      def inspect
        "Guess(#{guessed_char}/#{confidence})"
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
      guess_all(scanned_char).select { |guess|
        guess.confidence > 0 &&
        guess.confidence <= confidence
      }
    end

    private

    def guess_all(scanned_char)
      SCANNABLE_CHARS.map { |sc|
        Guess.new(scanned_char, sc)
      }.sort
    end
  end

  RECOGNIZER = Recognizer.new

end
