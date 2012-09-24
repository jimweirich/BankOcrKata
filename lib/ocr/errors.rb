module OCR

  class StandardError < ::StandardError
    attr_accessor :line_number

    def initialize(*args)
      super
      @line_number = nil
    end
  end

  class IllformedScannedNumberError < OCR::StandardError
  end

end
