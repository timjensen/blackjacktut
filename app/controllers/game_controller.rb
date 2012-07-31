class GameController < ApplicationController
  
  def index
    # Set default bet amount
    session[:bet] = "100";
  end
  
  def deal
    # Check if player has enough money in there bankroll
    if got_the_dollars?
      # Set gamestate
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
    dealer_ftw
    # Calculate winner
    find_winner
  end

  def double
    if got_the_dollars?
      deduction
      session[:bet] = session[:bet].to_f * 2
      next_card
      # Check if player has hone bust
      check_if_bust
      if session[:gamestate] != "Over"
        dealer_ftw
        # Calculate winner
        find_winner
      end
      session[:bet] = session[:bet].to_f / 2
    else
      flash.now[:error] = "You're Broke Fool"
    end
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
      # Set gamestate
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
    # If statement to check for blackjack
    if (session[:player_hand].score > 21)
    # Set flash error
    flash.now[:error] = "You Have Gone Bust"
    # Set gamestate
    session[:gamestate] = "Over"
    end
  end
  
  def find_winner
     # Set users score variable using session
    score = session[:player_hand].score
    # Set dealers score variable using session
    d_score = session[:dealer_hand].score
    # Set bet variable using session
    bet = session[:bet].to_f
    # Set dollars variable using users bankroll
    dollars = session[:user].bankroll.to_f
    # If score is greater than 21   
    if (score > 21)
      flash.now[:error] = "Dealer Wins"
    # If users score matches dealers score
    elsif (score == d_score)
      flash.now[:success]  = "Push"
      dollars += bet
    # If delaers score is greater than 21 or users score is greater than dealers score
    elsif (d_score > 21 or (score > d_score))
      flash.now[:success]  = "You Win!"
      dollars += (bet * 2)
    else
      flash.now[:error] = "Dealer Wins"
    end
    session[:gamestate] = "Over"
    session[:user].bankroll = dollars
    session[:user].save
  end
  
  def dealer_ftw
     # Get session hand
      dhand = session[:dealer_hand]
     # Add new cards to dealers hand untill dealers score exceeds 16
      dhand.cards << Card.new while(Hand.score_of(dhand) < 17)
     # Update dealers hand score    
      dhand.score = Hand.score_of(dhand)
      # Update session variable
      session[:dealer_hand] = dhand
  end
  
end
