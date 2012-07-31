class GameController < ApplicationController
  
  def index
    # Set default bet amount
    session[:bet] = "25";
  end
  
  def deal
    # Check if player has enough money in there bankroll
    if got_the_dollars?
      
      session[:gamestate] = "Dealt"
      # Deducted wager from bankroll as soon as deal
      deduction
      # Shuffle deck
      Card.shuffle
      # Players initial two cards
      hand = Hand.new
      hand.cards << Card.new << Card.new
      # Calculate score of initial hand
      hand.score = Hand.score_of(hand)
      # Set session variable for players hand
      session[:player_hand] = hand
      # Dealers initial two cards
      dhand = Hand.new
      dhand.cards << Card.new
      # Only show value of one card total value hidden from player
      dhand.score = Hand.score_of(dhand)
      dhand.cards << Card.new
      # Set session variable for dealers hand 
      session[:dealer_hand] = dhand
      # Check players hand for blackjack
      check_for_bj
    else
      flash.now[:error] = "You're Broke Fool"
  end
end
def hit
    # Produces next card and adds it to players hand
    next_card
    # Set third (removes double button)
    session[:gamestate] = "Third"
    # Check player has not gone bust
    check_if_bust
end

def stay
end

def double
end
  
  private
  
  def got_the_dollars?
    bank = session[:user].bankroll.to_f
    want = session[:bet].to_f
    bank >= want
  end
  
  def deduction
    bet = session[:bet].to_f
    dollars = session[:user].bankroll.to_f
    dollars -= bet
    session[:user].bankroll = dollars
    session[:user].save
  end
  
  def check_for_bj
    # If player hits blackJack
    if (session[:player_hand].score == 21)
      # Set bet variable using session
      bet = session[:bet].to_f
      # Set dollars variable using users bankroll
      dollars = session[:user].bankroll.to_f
      # Set result variables 
      flash.now[:success] = "Congratulations You Hit BlackJack!!"
      
      session[:gamestate] = "Over"
      # Sets chippy variable to unlock betting
      dollars += (bet * 3.5)
      # Update users rank roll
      session[:user].bankroll = dollars
      # Save updated user
      session[:user].save
    end
  end
  
   def next_card
     # Set hand variable using session variable
    hand = session[:player_hand]
    # Create new card
    @card = Card.new
    # Add new card to players hand
    hand.cards << @card
    # Calculate players new hand score
    hand.score = Hand.score_of(hand)
    # Update session variable to updated hand
    session[:player_hand] = hand
  end
  
  def check_if_bust
    if (session[:player_hand].score > 21)
    # Set variables
    flash.now[:error] = "You Have Gone Bust"
    session[:gamestate] = "Over"
  end
  end
  
end
