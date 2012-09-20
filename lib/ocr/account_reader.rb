module OCR
  class AccountReader
    def initialize(instream)
      @gr = GlyphReader.new(instream)
    end

    def next
      g = @gr.next
      return nil unless g
      g.value
    end
  end
end
