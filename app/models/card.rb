class Card < ActiveRecord::Base
  belongs_to :hand
  belongs_to :round


  def get_suit 
    case self.suit
    when 1
      return "Hearts"
    when 2      
      return "Clubs"
    when 3
      return "Spades"
    when 4
      return "Diamonds"
    end 
  end
  
  def get_symbol
    case self.suit
    when 1
      return "&hearts;"
    when 2      
      return "&clubs;"
    when 3
      return "&spades;"
    when 4
      return "&diams;"
    end 
  end  

  def get_value
    if self.value > 10
      return 10
    end
    if self.value == 1
      return 11
    end
    return value
  end

  def get_name
    card_name = ""
    case self.value
    when 1
      card_name = "A"
    when 13     
      card_name = "K"
    when 12
      card_name = "Q"
    when 11
      card_name = "J"
    else
      card_name = value  
    end
    return card_name.to_s + self.get_symbol 
  end  
end
