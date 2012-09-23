require 'rspec/given'

describe "Error handling" do
  def contents_of(file_name)
    open(file_name) { |f| f.read }
  end

  Given(:output_directory) { "tmp" }
  Given(:input_file_name)  { "stories/errors.in" }
  Given(:answer_file_name) { "stories/errors.ans" }
  Given(:output_file_name) { "#{output_directory}/errors.out" }

  Given { FileUtils.mkdir_p output_directory rescue nil }
  Given(:output) { contents_of(output_file_name) }
  When(:result) { system "ruby -Ilib bin/ocr <#{input_file_name} >#{output_file_name}" }

  Then { result.should be_false }
  And  { output.should =~ /error detected/i }
  And  { output.should =~ /line 9/i }
  And  { output.should =~ /this is a bad input/i }
end
