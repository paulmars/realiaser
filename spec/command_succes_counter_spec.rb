require 'spec_helper'

# Specing
module Realiased
  class CommandSuccessCounter
    @@default_file_location = "~/.realiaser_success_metrics.spec"
    @@history_file = "~/.realiaser_history.spec"
  end
end

describe Realiased::CommandSuccessCounter do
  it "can be created with defaults" do
    csc = Realiased::CommandSuccessCounter.new
    csc.high_score.should == 0
    csc.score.should == 0
    csc.high_score_at.should_not be_nil
  end

  context "metrics file doesn't exist" do
    before do
      File.stub!(:exists?).and_return(false)
    end

    it "has default data" do
      csc = Realiased::CommandSuccessCounter.new
      csc.high_score.should == 0
      csc.score.should == 0
      csc.high_score_at.should_not be_nil
    end
  end

  context "metrics file exists" do
    before do
      File.stub!(:exists?).and_return(true)

      yaml_string = {
        :score => 5,
        :high_score => 10,
        :high_score_at => Time.now,
      }.to_yaml
      file = mock(read: yaml_string)
      File.stub!(:new).and_return(file)
    end

    it "loads the file in to defaults" do
      csc = Realiased::CommandSuccessCounter.new
      csc.high_score.should == 10
      csc.score.should == 5
      csc.high_score_at.should_not be_nil
    end

    context "BUT is corrupt" do
      before do
        yaml_string = {
          bad: "data string"
        }.to_yaml
        file = mock(read: yaml_string)
        File.stub!(:new).and_return(file)
      end

      it "loads the file in to defaults" do
        csc = Realiased::CommandSuccessCounter.new
        csc.high_score.should == 0
        csc.score.should == 0
        csc.high_score_at.should_not be_nil
      end
    end
  end
end
