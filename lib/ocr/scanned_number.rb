require 'ocr/scanned_characters'

module OCR
  class IllformedScannedNumberError < StandardError; end

  class ScannedNumber
    include ScannedCharacters

    attr_reader :scanned_lines
    attr_reader :value

    def initialize(lines)
      @scanned_lines = lines
      normalize_line_lengths
      check_proper_number_of_lines
      check_for_illegal_characters
      check_line_lengths
      @value = calculate_value
    end

    def legible?
      ! illegible?
    end

    def illegible?
      value =~ /[?]/
    end

    def ==(other)
      scanned_lines == other.scanned_lines
    end

    def to_s
      value
    end

    def show
      to_s
    end

    def self.from_digits(string)
      first, *rest = string.chars.map { |nc| FROM_DIGIT[nc] || ["   ", "   ", "   "] }
      lines = first.zip(*rest).map { |f| f.join }
      new(lines)
    end

    def scanned_chars
      @scanned_chars ||=
        begin
          tops, mids, bots = scanned_lines.map { |ln| by_width(ln) }
          tops.zip(mids, bots).map { |en| en.join }
        end
    end

    private

    def calculate_value
      scanned_chars.map { |en|
        TO_DIGIT[en] || "?"
      }.join
    end

    def by_width(string)
      ScannedCharacters.by_width(string)
    end

    def normalize_line_lengths
      max_length = scanned_lines.map { |str| str.size }.max
      scanned_lines.each do |str|
        if str.size < max_length
          str << " " * (max_length - str.size)
        end
      end
    end

    def check_proper_number_of_lines
      if scanned_lines.length != 3
        fail IllformedScannedNumberError, "Must be three lines in #{show_lines}"
      end
    end

    def check_for_illegal_characters
      unless scanned_lines.all? { |string| string =~ /^[ |_]+$/ }
        fail IllformedScannedNumberError, "Illegal characters in #{show_lines}"
      end
    end

    def check_line_lengths
      lengths = scanned_lines.map { |ln| ln.length }.uniq
      if lengths.size > 1
        fail IllformedScannedNumberError, "Mismatching line lengths in #{show_lines}"
      end
      if (lengths.first % 3) != 0
        fail IllformedScannedNumberError, "Line lengths must be divisible by 3 in #{show_lines}"
      end
    end

    def show_lines
      "\n" + scanned_lines.join("\n")
    end
  end

end
