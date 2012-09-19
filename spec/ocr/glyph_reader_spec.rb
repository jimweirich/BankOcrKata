require 'spec_helper'

describe OCR::LineGroup do
  Given(:input_io) { StringIO.new(input) }
  Given(:group) { OCR::LineGroup.new(input_io) }

  context "with a single group" do
    When(:result) { group.next }

    context "when the group is terminated by an end of file" do
      Given(:input) { "a\nb\n" }
      Then { result.should == ["a\n", "b\n"] }
    end

    context "when the group is terminated by a a blank line" do
      Given(:input) { "a\nb\n\n" }
      Then { result.should == ["a\n", "b\n"] }
    end

    context "when the group begins with a line containing spaces" do
      Given(:input) { " \nb\n\n" }
      Then { result.should == [" \n", "b\n"] }
    end

    context "when there is no group" do
      Given(:input) { "" }
      Then { result.should be_nil }
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
    Given(:input) { "a\nb\nc\n\nx\ny\nz\n" }
    Then { result.should == [["a\n", "b\n", "c\n"], ["x\n", "y\n", "z\n"]] }
  end
end
