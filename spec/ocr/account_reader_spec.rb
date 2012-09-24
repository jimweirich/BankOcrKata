require 'spec_helper'

module OCR

  describe AccountReader do
    Given(:input_io) { StringIO.new(input) }
    Given(:reader) { AccountReader.new(input_io) }

    context "with a single scanned number" do
      When(:result) { reader.read_account_number }

      context "terminated by an end of file" do
        Given(:input) {
          " _ \n" +
          "|_ \n" +
          " _|\n"
        }
        Then { result.should == ScannedNumber.from_digits("5") }
      end

      context "terminated by a a blank line" do
        Given(:input) {
          " _ \n" +
          "|_ \n" +
          " _|\n" +
          "\n"
        }
        Then { result.should == ScannedNumber.from_digits("5") }
      end


      context "with some lines shortened due to trailing blanks" do
        Given(:input) {
          " _\n" +
          "|_ \n" +
          " _|\n" +
          "\n"
        }
        Then { result.should == AccountNumber.from_digits("5") }
      end

      context "beginning with a line containing spaces" do
        Given(:input) {
          "   \n" +
          "  |\n" +
          "  |\n" +
          "\n"
        }
        Then { result.should == AccountNumber.from_digits("1") }
      end

      context "containing multiple numerals" do
        Given(:input) {
          "    _  _ \n" +
          "  | _| _|\n" +
          "  ||_  _|\n" +
          "\n"
        }
        Then { result.should == AccountNumber.from_digits("123") }
      end

      context "when there is no scanned number" do
        Given(:input) { "" }
        Then { result.should be_nil }
      end

    end

    context "with multiple account numbers" do
      Given(:validate) { true }
      Given(:input) {
        "    _  _     _  _  _  _  _ \n" +
        "  | _| _||_||_ |_   ||_||_|\n" +
        "  ||_  _|  | _||_|  ||_| _|\n" +
        "\n" +
        " _  _  _  _  _  _  _  _    \n" +
        "| || || || || || || ||_   |\n" +
        "|_||_||_||_||_||_||_| _|  |\n" +
        "\n"
      }

      When(:result) { reader.to_a }

      Then { result.should == [
          AccountNumber.from_digits("123456789"),
          AccountNumber.from_digits("000000051"),
        ]
      }
    end
  end

end
