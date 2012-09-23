require 'ocr/scanned_number'

module OCR
  class AccountNumber < ScannedNumber
    def valid?
      legible? && CHECKER.check?(value)
    end

    def show
      if valid?
        value
      elsif illegible?
        "#{value} ILL"
      else
        "#{value} ERR"
      end
    end
  end

end
