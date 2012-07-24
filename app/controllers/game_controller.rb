class GameController < ApplicationController
  
  def index
    # Set default bet amount
    session[:bet] = "25";
  end
  
  def deal
    # Check if player has enough money in there bankroll
    if got_the_dollars?
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
      flash.now[:error] = 'Your Broke Fool'
  end
end
  
  private
  
  def got_the_dollars?
    bank = current_user.bankroll.to_f
    want = session[:bet].to_f
    bank >= want
  end
  
  def deduction
    bet = session[:bet].to_f
    dollars = current_user.bankroll.to_f
    dollars -= bet
    current_user.bankroll = dollars
    current_user.save
  end
  
  def check_for_bj
    # If player hits blackJack
    if (session[:player_hand].score == 21)
      # Set bet variable using session
      bet = session[:bet].to_f
      # Set dollars variable using users bankroll
      dollars = current_user.bankroll.to_f
      # Set result variables 
      flash[:success] = "Congratulations You Hit BlackJack!!"
      # Sets chippy variable to unlock betting
      dollars += (bet * 3.5)
      # Update users rank roll
      current_user.bankroll = dollars
      # Save updated user
      current_user.save
    end
  end
  
end
