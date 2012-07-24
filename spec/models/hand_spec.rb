require 'spec_helper'

describe Hand do
  before { @hand = Hand.new } 
  subject { @hand }
  
  it { should respond_to(:score) }
  it { should respond_to(:cards) }
  
  describe "initial score should be zero" do
    subject { @score }
    before { @score = @hand.score }
    it { should == 0 }
  end
  
  describe "initial card array should be empty" do
    subject { @cards }
    before { @cards = @hand.cards.count }
    it { should == 0 }
  end
  
  describe "build a hand" do
    subject { @cards }
    before do
      @@pos = 0
      @hand.cards << Card.new << Card.new 
      @cards = @hand.cards.count
    end
    it { should == 2 }
  end
  
  describe "score a hand" do
    before { Hand.score_of(@hand)}
    it { should_not = 0 }
  end
  
end