require 'spec_helper'

describe Realiased::CommandSuccessCounter do
  it "can be created with defaults" do
    csc = Realiased::CommandSuccessCounter.new
    csc.high_score.should == 1
    csc.score.should == 1
    csc.high_score_at.should be_nil
  end
end
