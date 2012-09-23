require 'ocr/scanned_number'

module OCR
  class AccountReader
    include Enumerable

    def initialize(in_stream, opts={})
      @in_stream = in_stream
    end

    def read_account_number
      result = (0...3).map { read_line }
      read_line
      if result.any? { |ln| ln.nil? }
        nil
      else
        AccountNumber.new(result)
      end
    end

    def each
      while line = read_account_number
        yield line
      end
    end

    private

    def read_line
      result = @in_stream.gets
      result && result.chomp
    end
  end

end
