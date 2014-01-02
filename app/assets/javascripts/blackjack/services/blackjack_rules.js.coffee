angular.module('blackjack').factory 'BlackjackRules', ->

  getHandScore: (cards) ->
    score = 0
    aces = 0
    angular.forEach cards, (card) =>
      value = @getCardValue(card)
      aces++ if value == 11
      score += value
    while score > 21 && aces > 0
      score -= 10
      aces--
    score


  getCardValue: (card) ->
    if card.value > 10
      return 10
    if card.value == 1
      return 11
    card.value


  