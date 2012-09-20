module OCR
  class IllformedGlyphError < StandardError; end

  class Glyph
    TO_DIGIT = {
      " _ | ||_|" => "0",
      "     |  |" => "1",
      " _  _||_ " => "2",
      " _  _| _|" => "3",
      "   |_|  |" => "4",
      " _ |_  _|" => "5",
      " _ |_ |_|" => "6",
      " _   |  |" => "7",
      " _ |_||_|" => "8",
      " _ |_| _|" => "9",
    }

    attr_reader :value

    def initialize(lines)
      @lines = lines
      normalize_line_lengths
      check_proper_number_of_lines
      check_for_illegal_characters
      check_line_lengths
      @value = calculate_value
    end

    def ==(other)
      @lines == other.lines
    end

    attr_reader :lines
    protected :lines

    private

    def calculate_value
      tops, mids, bots = lines.map { |ln| ln.scan(/.../) }
      encodings = tops.zip(mids, bots).map { |en| en.join }
      encodings.map { |en|
        TO_DIGIT[en] or fail IllformedGlyphError, "Unrecognized digit #{en}"
      }.join
    end

    def normalize_line_lengths
      max_length = lines.map { |str| str.size }.max
      lines.each do |str|
        if str.size < max_length
          str << " " * (max_length - str.size)
        end
      end
    end

    def check_proper_number_of_lines
      if @lines.length != 3
        fail IllformedGlyphError, "Must be three lines in #{show_lines}"
      end
    end

    def check_for_illegal_characters
      unless @lines.all? { |string| string =~ /^[ |_]+$/ }
        fail IllformedGlyphError, "Illegal characters in #{show_lines}"
      end
    end

    def check_line_lengths
      lengths = @lines.map { |ln| ln.length }.uniq
      if lengths.size > 1
        fail IllformedGlyphError, "Mismatching line lengths in #{show_lines}"
      end
      if (lengths.first % 3) != 0
        fail IllformedGlyphError, "Line lengths must be divisible by 3 in #{show_lines}"
      end
    end

    def show_lines
      "\n" + @lines.join("\n")
    end
  end

end
