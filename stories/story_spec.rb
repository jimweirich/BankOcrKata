require 'rspec/given'

describe "User Stories" do
  def contents_of(file_name)
    open(file_name) { |f| f.read }
  end

  Given(:compliance_level) { 4 }

  Given(:output_directory) { "tmp" }
  Given(:input_file_name)  { "stories/usecase#{story}.in" }
  Given(:answer_file_name) { "stories/usecase#{story}_#{compliance_level}.ans" }
  Given(:output_file_name) { "#{output_directory}/usecase#{story}.out" }

  Given { FileUtils.mkdir_p output_directory rescue nil }

  When(:result) { system "ruby -Ilib bin/ocr <#{input_file_name} >#{output_file_name}" }

  Invariant { result.should be_true }
  Invariant { contents_of(output_file_name).should == contents_of(answer_file_name) }

  context "#1" do
    Given { pending "Completion of User Story 1" if compliance_level < 1 }
    Given(:story) { 1 }
    Then { }
  end

  context "#3" do
    Given { pending "Completion of User Story 3" if compliance_level < 3 }
    Given(:story) { 3 }
    Then { }
  end

  context "#4" do
    Given { pending "Completion of User Story 4" if compliance_level < 4 }
    Given(:story) { 4 }
    Then { }
  end
end
