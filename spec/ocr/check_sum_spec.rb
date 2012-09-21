require 'spec_helper'

describe OCR::CheckSum do
  Given(:checker) { OCR::CheckSum.new }

  describe "#checksum" do
    Then { checker.check_sum("000000000").should == 0 }
    Then { checker.check_sum("111111111").should == 1 }
    Then { checker.check_sum("222222222").should == 2 }
    Then { checker.check_sum("333333333").should == 3 }
    Then { checker.check_sum("123456789").should == 0 }
  end

  describe "#check?" do
    context "when the account number is good" do
      Then { checker.check?("000000000").should be_true }
      Then { checker.check?("000000051").should be_true }
      Then { checker.check?("345882865").should be_true }
      Then { checker.check?("457508000").should be_true }
      Then { checker.check?("123456789").should be_true }
    end

    context "when the account number is bad" do
      Then { checker.check?("111111111").should_not be_true }
      Then { checker.check?("222222222").should_not be_true }
      Then { checker.check?("490067715").should_not be_true }
      Then { checker.check?("664371495").should_not be_true }
    end
  end
end
