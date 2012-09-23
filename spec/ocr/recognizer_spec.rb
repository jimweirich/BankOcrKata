require 'spec_helper'

module OCR

  describe Recognizer do
    Given(:recog) { Recognizer.new }
    Then { recog.should_not be_nil }

    describe "recognizing" do
      Recognizer::SCANNABLE_CHARS.each.with_index do |sc, i|
        context "a scanned character '#{sc}'" do
          Then { recog.recognize(sc).should == i.to_s }
        end
      end

      context "an invalid scanned character" do
        Given(:scanned_char) { "  |  |  |" }
        Then { recog.recognize(scanned_char).should == '?' }
      end
    end

    describe "guessing" do
      context "with no confidence limits" do
        Given(:scanned_char) {  "  |  |  |" }
        Given(:expected_guesses) {
          Recognizer::SCANNABLE_CHARS.map { |c| Recognizer::Guess.new(scanned_char, c) }.sort
        }

        When(:result) { recog.guess(scanned_char) }

        Then { result.should == expected_guesses }
      end

      context "with a confidence level of 1" do
        Given(:scanned_char) {  "  |  |  |" }
        Given(:expected_guesses) { [ Recognizer::Guess.new(scanned_char, "     |  |") ] }

        When(:result) { recog.guess(scanned_char, 1) }

        Then { result.should == expected_guesses }
      end
    end

  end

end
