class Card
  
  attr_reader :card_front
  # Standard deck of cards
  @@deck = %w(ah ac ad as 2h 2c 2d 2s 3h 3c 3d 3s 
              4h 4c 4d 4s 5h 5c 5d 5s 6h 6c 6d 6s 
              7h 7c 7d 7s 8h 8c 8d 8s 9h 9c 9d 9s 
              th tc td ts jh jc jd js qh qc qd qs 
              kh kc kd ks)
              
  # Shuffle deck action
  def self.shuffle
    # Defaults back to first card in card array
    @@pos = 0
    # Re-orders deck by sorting by random to mimic shuffling
    @@deck = @@deck.sort_by{ rand }
  end
              
  # Initialize new card
  def initialize
    # Grabs next card in deck
    @card_front = @@deck[@@pos]
    # Increases deck position by one to allow next card drawn to be unique
    @@pos += 1
  end
  
  # Calculate card value 
  def self.value(card_front, score)
    # Default value
    value = 0
    # Numeral cards set to face value
    if card_front =~ /\d/
      value += card_front[0,1].to_i
    # Aces set to 1 or 11 dependant on current score
    elsif card_front =~ /a/
      if score + 11 > 21
        value = 1
      else
        value = 11
      end
    # Royal cards and 10s set to 10
    else
      value = 10
    end
    # Return value
    value
  end
  
end