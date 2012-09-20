require 'ocr/glyph'

module OCR

  class GlyphReader
    def initialize(in_stream)
      @in_stream = in_stream
    end

    def next
      result = []
      3.times {
        line = @in_stream.gets
        return nil if line.nil?
        result << line.chomp
      }
      @in_stream.gets
      Glyph.new(result)
    end
  end
end
