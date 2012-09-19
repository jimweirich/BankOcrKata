require 'spec_helper'

describe OCR::GlyphReader do
  Given(:input_io) { StringIO.new(input) }
  Given(:group) { OCR::GlyphReader.new(input_io) }

  context "with a single glyph" do
    When(:result) { group.next }

    context "terminated by an end of file" do
      Given(:input) {
        " _ \n" +
        "|_ \n" +
        " _|\n"
      }
      Then { result.should == [
          " _ ",
          "|_ ",
          " _|"  ]
      }
    end

    context "terminated by a a blank line" do
      Given(:input) {
        " _ \n" +
        "|_ \n" +
        " _|\n" +
        "\n"
      }
      Then { result.should == [
          " _ ",
          "|_ ",
          " _|"  ]
      }
    end

    context "beginning with a line containing spaces" do
      Given(:input) {
        "   \n" +
        "  |\n" +
        "  |\n" +
        "\n"
      }
      Then { result.should == [
          "   ",
          "  |",
          "  |" ]
      }
    end

    context "containing multiple numerals" do
      Given(:input) {
        "    _  _ \n" +
        "  | _| _|\n" +
        "  ||_  _|\n" +
        "\n"
      }
      Then { result.should == [
          "    _  _ ",
          "  | _| _|",
          "  ||_  _|" ]
      }
    end

    context "when there is no glyph" do
      Given(:input) { "" }
      Then { result.should be_nil }
    end

    context "with illegal characters" do
      Given(:input) {
        "    _  _ \n" +
        "  | _| _|\n" +
        "  ||_ x_|\n" +
        "\n"
      }
      Then { result.should have_failed(OCR::IllformedGlyphError, /illegal character/i)  }
    end

    context "with mismatching line lengths" do
      Given(:input) {
        "    _  _    \n" +
        "  | _| _|\n" +
        "  ||_  _|\n" +
        "\n"
      }
      Then { result.should have_failed(OCR::IllformedGlyphError, /mismatch.*length/i)  }
    end

    context "with lines lengths not divisible by 3" do
      Given(:input) {
        "    _  _  \n" +
        "  | _| _| \n" +
        "  ||_  _| \n"
      }
      Then { result.should have_failed(OCR::IllformedGlyphError, /length.*(3|three)/i)  }
    end

    context "with missing lines" do
      Given(:input) {
        "    _  _ \n" +
        "  | _| _|\n"
      }
      Then { result.should have_failed(OCR::IllformedGlyphError, /(3|three) lines/i)  }
    end
  end

  context "with multiple groups" do
    When(:result) {
      result = []
      while g = group.next
        result << g
      end
      result
    }
    Given(:input) {
      "    _  _ \n" +
      "  | _| _|\n" +
      "  ||_  _|\n" +
      "\n" +
      "    _  _ \n" +
      "|_||_ |_ \n" +
      "  | _||_|\n" +
      "\n"
    }
    Then { result.should == [
        [ "    _  _ ",
          "  | _| _|",
          "  ||_  _|" ],
        [ "    _  _ ",
          "|_||_ |_ ",
          "  | _||_|" ],
      ]
    }
  end
end
