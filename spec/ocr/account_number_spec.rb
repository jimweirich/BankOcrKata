require 'spec_helper'

module OCR

  describe AccountNumber do
    Given(:acct) { AccountNumber.from_digits(digits) }

    context "with legible digits" do
      Given(:digits) { "345882865" }
      Then { acct.should be_valid }
      Then { acct.should be_legible }
      Then { acct.show.should == digits }
    end

    context "with illegible digits" do
      Given(:digits) { "49006771?" }
      Then { acct.should_not be_valid }
      Then { acct.should_not be_legible }
      Then { acct.show.should == "#{digits} ILL" }
    end

    context "with invalid digits" do
      Given(:digits) { "345862865" }
      Then { acct.should_not be_valid }
      Then { acct.should be_legible }
      Then { acct.show.should == "#{digits} ERR" }
    end

    context "with short digits" do
      Given(:digits) { "00000000" }
      Then { acct.should_not be_valid }
      Then { acct.should be_legible }
      Then { acct.show.should == "#{digits} ERR" }
    end
  end

end
