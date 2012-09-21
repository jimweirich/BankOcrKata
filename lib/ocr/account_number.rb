module OCR
  class AccountNumber < Glyph
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
