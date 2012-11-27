require 'spec_helper'

# Specing
module Realiased
  class CommandSuccessCounter
    @@default_file_location = "~/.realiaser_success_metrics.spec"
    @@history_file = "~/.realiaser_history.spec"
  end
end

describe Realiased::CommandSuccessCounter do
  # start with a empty file
  before do
    File.stub!(:exists?).and_return(false)
  end

  it "can be created with defaults" do
    csc = Realiased::CommandSuccessCounter.new
    csc.high_score.should == 0
    csc.score.should == 0
    csc.high_score_at.should_not be_nil
  end

  it "correct line" do
    csc = Realiased::CommandSuccessCounter.new
    csc.score.should == 0
    csc.correct!("ls")
    csc.score.should == 1
  end

  it "doesn't accept last line multiple times" do
    csc = Realiased::CommandSuccessCounter.new
    csc.score.should == 0
    csc.correct!("ls")
    csc.correct!("ls")
    csc.score.should == 1
  end

  it "marks high score" do
    csc = Realiased::CommandSuccessCounter.new
    csc.score.should == 0
    csc.correct!("ls")
    csc.high_score.should == 1

    csc.correct!("ls -G")
    csc.high_score.should == 2
  end

  it "decreases if a mistake is added" do
    csc = Realiased::CommandSuccessCounter.new
    csc.correct!("ls")
    csc.high_score.should == 1

    csc.mistake!("bad command")
    csc.high_score.should == 0
  end

  context "metrics file doesn't exist" do
    before do
      File.stub!(:exists?).and_return(false)

      path = Realiased::CommandSuccessCounter.path
      file = mock({
        :read => "sdf",
        :<< => nil,
        :close => nil,
      })
      File.stub(:new).with(path, 'w').and_return(file)
    end

    it "has default data" do
      csc = Realiased::CommandSuccessCounter.new
      csc.high_score.should == 0
      csc.score.should == 0
      csc.high_score_at.should_not be_nil
    end

    it "writes a file" do
      File.should_receive(:new).with(path, 'w').and_return(file)
      Realiased::CommandSuccessCounter.new
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

    context "BUT doesn't have data" do
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

    context "BUT is corrupt" do
      before do
        file = mock(read: "CORRUPT YAML")
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
