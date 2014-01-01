angular.module('blackjack').directive 'card', ->
  restrict: 'E'
  scope: 
    index: "="
    card: "="
  templateUrl: '/assets/card.tpl.html' 
  replace: true
  tranclude: true
  link: (scope, element, attrs) ->
    console.log attrs
    attrs.$observe 'card', (val) ->
      console.log val
      symbol = getSymbol(val.suit)
      suit = getSuit(val.suit)
      scope.name = getName(val.value, symbol)

      element.addClass(getSuit(val.suit))

    getSuit = (suit) ->
      switch suit
        when 1 
          "hearts"
        when 2
          "clubs"
        when 3
          "spades"
        when 4
          "diamonds"

    getSymbol = (suit) ->
      switch suit
        when 1 
          "&hearts;"
        when 2
          "&clubs;"
        when 3
          "&spades;"
        when 4
          "&diams;"
        
      
    getName = (value, cardSymbol) ->
      cardName = ""
      switch value
        when 1
          cardName = "A"
        when 13     
          cardName = "K"
        when 12
          cardName = "Q"
        when 11
          cardName = "J"
        else
          cardName = value  
      cardName + cardSymbol 