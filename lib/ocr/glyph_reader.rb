module OCR

  class IllformedGlyphError < StandardError; end

  class GlyphReader
    def initialize(in_stream)
      @in_stream = in_stream
    end

    def next
      result = []
      while line = @in_stream.gets
        break if line.empty? || line == "\n"
        result << line.chomp
      end
      return nil if result.empty?
      check_proper_number_of_lines(result)
      check_for_illegal_characters(result)
      check_line_lengths(result)
      result
    end

    private

    def check_proper_number_of_lines(glyph)
      if glyph.length != 3
        fail IllformedGlyphError, "Must be three lines in #{glyph}"
      end
    end

    def check_for_illegal_characters(glyph)
      unless glyph.all? { |string| string =~ /^[ |_]+$/ }
        fail IllformedGlyphError, "Illegal characters in #{glyph}"
      end
    end

    def check_line_lengths(glyph)
      lengths = glyph.map { |g| g.length }.uniq
      if lengths.size > 1
        fail IllformedGlyphError, "Mismatching line lengths in #{glyph}"
      end
      if (lengths.first % 3) != 0
        fail IllformedGlyphError, "Line lengths must be divisible by 3 in #{glyph}"
      end
    end
  end

end
