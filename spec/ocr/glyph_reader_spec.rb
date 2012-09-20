require 'spec_helper'

describe OCR::GlyphReader do
  Given(:input_io) { StringIO.new(input) }
  Given(:group) { OCR::GlyphReader.new(input_io) }

  context "with a single glyph" do
    Given(:lines) { result.lines }

    When(:result) { group.next }

    context "terminated by an end of file" do
      Given(:input) {
        " _ \n" +
        "|_ \n" +
        " _|\n"
      }
      Then { result.should == OCR::Glyph.new([
            " _ ",
            "|_ ",
            " _|"  ])
      }
    end

    context "terminated by a a blank line" do
      Given(:input) {
        " _ \n" +
        "|_ \n" +
        " _|\n" +
        "\n"
      }
      Then { result.should == OCR::Glyph.new([
            " _ ",
            "|_ ",
            " _|"  ])
      }
    end


    context "with some lines shortened due to trailing blanks" do
      Given(:input) {
        " _\n" +
        "|_ \n" +
        " _|\n" +
        "\n"
      }
      Then { result.should == OCR::Glyph.new([
            " _ ",
            "|_ ",
            " _|"  ])
      }
    end

    context "beginning with a line containing spaces" do
      Given(:input) {
        "   \n" +
        "  |\n" +
        "  |\n" +
        "\n"
      }
      Then { result.should == OCR::Glyph.new([
            "   ",
            "  |",
            "  |" ])
      }
    end

    context "containing multiple numerals" do
      Given(:input) {
        "    _  _ \n" +
        "  | _| _|\n" +
        "  ||_  _|\n" +
        "\n"
      }
      Then { result.should == OCR::Glyph.new([
            "    _  _ ",
            "  | _| _|",
            "  ||_  _|" ])
      }
    end

    context "when there is no glyph" do
      Given(:input) { "" }
      Then { result.should be_nil }
    end

  end

  context "with multiple groups" do
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

    When(:result) {
      result = []
      while g = group.next
        result << g
      end
      result
    }

    Then { result.should == [
        OCR::Glyph.new([
            "    _  _ ",
            "  | _| _|",
            "  ||_  _|" ]),
        OCR::Glyph.new([
            "    _  _ ",
            "|_||_ |_ ",
            "  | _||_|" ]),
      ]
    }
  end
end
