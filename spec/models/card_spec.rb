require 'spec_helper'

describe Card do
  @@deck = %w(ah ac ad as 2h 2c 2d 2s 3h 3c 3d 3s 
              4h 4c 4d 4s 5h 5c 5d 5s 6h 6c 6d 6s 
              7h 7c 7d 7s 8h 8c 8d 8s 9h 9c 9d 9s 
              th tc td ts jh jc jd js qh qc qd qs 
              kh kc kd ks)
  @newcard = nil
                 
  describe "after cards have been shuffled" do
    subject { @@deck }
    let(:after_shuffle) { Card.shuffle }
    it { should_not == after_shuffle } 
  end
    
  describe "new card dealt" do
    subject { @newcard }
    before { @newcard = Card.new }
    it { should respond_to(:card_front) }
  end
  
  subject { @card_val }
  
  describe "value of a low ace" do
    before { @card_val = Card.value('ac', 1)}
    it { should == 11 }
  end
  
  describe "value of a high ace" do
    before { @card_val = Card.value('ac', 13)}
    it { should == 1 }
  end
  
  describe "value of a number card" do
    before { @card_val = Card.value('7c', 1)}
    it { should == 7 }
  end
  
  describe "value of any other cards" do
    before { @card_val = Card.value('th', 1)}
    it { should == 10 }
  end
end
  