require 'ocr/scanned_number'

module OCR
  class AccountNumber < ScannedNumber
    def valid?
      legible? && CHECKER.check?(value)
    end

    def valid_alternatives
      alternatives.select { |digits| CHECKER.check?(digits) }.sort
    end

    def show
      if valid?
        value
      else
        alts = valid_alternatives
        if alts.size == 1
          alts.first
        elsif alts.size > 1
          "#{value} AMB [" + alts.map { |a| "'#{a}'" }.join(", ") + "]"
        elsif illegible?
          "#{value} ILL"
        else
          "#{value} ERR"
        end
      end
    end
  end

end
