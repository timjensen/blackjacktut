class Hand
  
  attr_accessor :cards, :score
  
  # Initialize new hand
  def initialize
    #Sets cards array
    @cards = []
    # Sets score to zero
    @score = 0
  end
  
  def self.score_of(hand)
    # Default score
    score = 0
    
    # Calculates cards that arn't aces first so ace value can be determined
    hand.cards.each do |card|
      if card.card_front !~ /a/
        score += Card.value(card.card_front, score)
      end
    end
    # With non aces summed already can now figure out if an ace is 1 or 11
    hand.cards.each do |card|
      if card.card_front =~ /a/
        score += Card.value(card.card_front, score)
      end
    end
    # New score returned
    score
  end
  
end