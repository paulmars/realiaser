require 'spec_helper'

describe Realiased::AliasSuggestor do
  before do
    File.stub!(:new).and_return([
      "be='bundle exec",
      "sl='ls",
    ])
  end

  it "suggeset based on a file loaded" do
    as = Realiased::AliasSuggestor.new('STUB PATH')
    as.suggest("bundle exec").should == "be"

    as.suggest("bundle install").should be_nil
  end
end
