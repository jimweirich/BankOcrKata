require 'spec_helper'

module OCR

  describe ScannedNumber do

    context "when well formed" do
      Given(:number) { ScannedNumber.new(lines) }
      Invariant { number.should be_legible }
      Invariant { number.should_not be_illegible }
      Invariant { number.scanned_lines.should == lines }

      context "with a single numeral" do
        Given(:lines) {
          [ "   ",
            "  |",
            "  |" ]
        }
        Then { number.value.should == "1" }
        Then { number.scanned_chars.should == [lines.join] }
      end

      context "with another single numeral" do
        Given(:lines) {
          [ " _ ",
            " _|",
            " _|" ]
        }
        Then { number.value.should == "3" }
        Then { number.scanned_chars.should == [lines.join] }
      end

      context "with multiple numerals" do
        Given(:lines) {
          [ "    _ ",
            "  | _|",
            "  | _|" ]
        }
        Then { number.value.should == "13" }
        Then { number.scanned_chars.should == ["     |  |", " _  _| _|"] }
      end

      context "with all the numerals" do
        Given(:lines) {
          [ " _     _  _     _  _  _  _  _ ",
            "| |  | _| _||_||_ |_   ||_||_|",
            "|_|  ||_  _|  | _||_|  ||_| _|",
          ]
        }
        Then { number.value.should == "0123456789" }
      end
    end

    context "with an unrecognized digit" do
      Given(:lines) {
        [ "    _  _ ",
          "  | _  _|",
          "  ||_  _|" ]
      }
      When(:number) { ScannedNumber.new(lines) }
      Then { number.value.should == "1?3" }
      And  { number.should be_illegible }
      And  { number.should_not be_legible }
    end

    describe "illformed numbers" do
      When(:result) { ScannedNumber.new(lines) }

      context "with illegal characters" do
        Given(:lines) {
          [ "    _  _ ",
            "  | _| _|",
            "  ||_ x_|" ]
        }
        Then { result.should have_failed(IllformedScannedNumberError, /illegal character/i)  }
      end

      context "with lines lengths not divisible by 3" do
        Given(:lines) {
          [ "    _  _  ",
            "  | _| _| ",
            "  ||_  _| " ]
        }
        Then { result.should have_failed(IllformedScannedNumberError, /length.*(3|three)/i)  }
      end

      context "with missing lines" do
        Given(:lines) {
          [ "    _  _ ",
            "  | _| _|" ]
        }
        Then { result.should have_failed(IllformedScannedNumberError, /(3|three) lines/i)  }
      end
    end

    describe "creating numbers from digit strings" do
      When(:number) { ScannedNumber.from_digits(digits) }

      context "with legible chars" do
        Given(:digits) { "0123456789" }
        Then { number.value.should == digits }
        Then { number.show.should == digits }
      end

      context "with illegible chars" do
        Given(:digits) { "01234?6789" }
        Then { number.value.should == digits }
        Then { number.show.should == digits }
      end
    end

    describe "#scanned_chars" do
      context "with multiple numerals" do
        Given(:lines) {
          [ "    _ ",
            "  | _|",
            "  | _|" ]
        }
        Given(:number) { ScannedNumber.new(lines) }
        When(:result) { number.scanned_chars }
        Then { result.should == ["     |  |", " _  _| _|"] }
      end
    end

  end

end
