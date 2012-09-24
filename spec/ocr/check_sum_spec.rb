require 'spec_helper'

module OCR

  describe CheckSum do
    Given(:checker) { CHECKER }

    describe "#checksum" do
      Then { checker.check_sum("000000000").should == 0 }
      Then { checker.check_sum("777777777").should == 7 }
      Then { checker.check_sum("123456789").should == 0 }

      Then { checker.check_sum("000000002").should == (2*1) % 11 }
      Then { checker.check_sum("000000020").should == (2*2) % 11 }
      Then { checker.check_sum("000000200").should == (2*3) % 11 }
      Then { checker.check_sum("000002000").should == (2*4) % 11 }
      Then { checker.check_sum("000020000").should == (2*5) % 11 }
      Then { checker.check_sum("000200000").should == (2*6) % 11 }
      Then { checker.check_sum("002000000").should == (2*7) % 11 }
      Then { checker.check_sum("020000000").should == (2*8) % 11 }
      Then { checker.check_sum("200000000").should == (2*9) % 11 }
    end

    describe "#check?" do
      context "when the account number is good" do
        # good account numbers were taken from the user story specs
        Then { checker.check?("000000000").should be_true }
        Then { checker.check?("000000051").should be_true }
        Then { checker.check?("123456789").should be_true }
        Then { checker.check?("200800000").should be_true }
        Then { checker.check?("333393333").should be_true }
        Then { checker.check?("490867715").should be_true }
        Then { checker.check?("664371485").should be_true }
        Then { checker.check?("711111111").should be_true }
        Then { checker.check?("777777177").should be_true }
      end

      context "when the account number is bad" do
        # bad account numbers were taken from the user story specs
        Then { checker.check?("111111111").should_not be_true }
        Then { checker.check?("490067715").should_not be_true }
        Then { checker.check?("664371495").should_not be_true }
        Then { checker.check?("00000000").should_not be_true }
        Then { checker.check?("0000000000").should_not be_true }
      end
    end
  end

end
