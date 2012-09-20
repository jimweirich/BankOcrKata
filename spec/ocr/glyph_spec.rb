require 'spec_helper'

describe OCR::Glyph do

  describe "Values" do
    Given(:glyph) { OCR::Glyph.new(lines) }

    context "with a single numeral" do
      Given(:lines) {
        [ "   ",
          "  |",
          "  |" ]
      }
      Then { glyph.value.should == "1" }
    end

    context "with another single numeral" do
      Given(:lines) {
        [ " _ ",
          " _|",
          " _|" ]
      }
      Then { glyph.value.should == "3" }
    end

    context "with multiple numerals" do
      Given(:lines) {
        [ "    _ ",
          "  | _|",
          "  | _|" ]
      }
      Then { glyph.value.should == "13" }
    end

    context "with all the numerals" do
      Given(:lines) {
        [ " _     _  _     _  _  _  _  _ ",
          "| |  | _| _||_||_ |_   ||_||_|",
          "|_|  ||_  _|  | _||_|  ||_| _|",
        ]
      }
      Then { glyph.value.should == "0123456789" }
    end
  end


  describe "illformed glyphs" do
    When(:result) { OCR::Glyph.new(lines) }

    context "with illegal characters" do
      Given(:lines) {
        [ "    _  _ ",
          "  | _| _|",
          "  ||_ x_|" ]
      }
      Then { result.should have_failed(OCR::IllformedGlyphError, /illegal character/i)  }
    end

    context "with lines lengths not divisible by 3" do
      Given(:lines) {
        [ "    _  _  ",
          "  | _| _| ",
          "  ||_  _| " ]
      }
      Then { result.should have_failed(OCR::IllformedGlyphError, /length.*(3|three)/i)  }
    end

    context "with missing lines" do
      Given(:lines) {
        [ "    _  _ ",
          "  | _| _|" ]
      }
      Then { result.should have_failed(OCR::IllformedGlyphError, /(3|three) lines/i)  }
    end

    context "with an unrecognized digit" do
      Given(:lines) {
        [ "    _  _ ",
          "  | _  _|",
          "  ||_  _|" ]
      }
      Then { result.should have_failed(OCR::IllformedGlyphError, /digit/i)  }
    end

  end

end
