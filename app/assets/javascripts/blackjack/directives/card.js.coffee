angular.module('blackjack').directive 'blackjackCard', ($compile) ->
  restrict: 'E'
  scope: 
    card: "="
  templateUrl: '/assets/card.tpl.html' 
  replace: true
  tranclude: true
  link: (scope, element, attrs) ->
    scope.spade = "&spades;"
    scope.diamond = "&diams;"
    scope.club = "&clubs;"
    scope.heart = "&hearts;"

    scope.$watch('card', ->)

    scope.getClass = ->
      classes = scope.getSuit() + ' card'
      # classes += ' facedown' if scope.faceDown

    scope.getSuit = ->
      switch scope.card.suit
        when 1 
          "hearts"
        when 2
          "clubs"
        when 3
          "spades"
        when 4
          "diamonds"
        else
          ""
        
      
    scope.getName = ->
      cardName = ""
      switch scope.card.value
        when 1
          cardName = "A"
        when 13     
          cardName = "K"
        when 12
          cardName = "Q"
        when 11
          cardName = "J"
        else
          cardName = scope.card.value  
      cardName

