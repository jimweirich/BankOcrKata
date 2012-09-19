module OCR

  class LineGroup
    def initialize(in_stream)
      @in_stream = in_stream
    end

    def next
      result = []
      while line = @in_stream.gets
        break if line.empty? || line == "\n"
        result << line
      end
      result.empty? ? nil : result
    end
  end

end
