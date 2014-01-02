angular.module('blackjack').controller 'BlackjackCtrl', ($scope, $http, BlackjackRules) ->

  $scope.setName = false
  $scope.dealerHand = null
  $scope.playerHands = []
  $scope.user = {}
  $scope.currentHandIndex = null
  $scope.roundNumber = 0
  $scope.baseWager = 30
  $scope.bank = 0
  $scope.moneyInPlay = 0
  $scope.playerCount = 1
  $scope.playerPreferences = {}
  $scope.currentUser = null
  $scope.gameStarted = false
  $scope.wager = 50
  $scope.midRound = false
  $scope.roundHash = null

  $scope.$watch 'currentHandIndex', (newVal) ->
    if $scope.midRound && (newVal + 1) > $scope.playerHands.length
      $scope.ceaseAction = true 
      $scope.dealDealerHand()

  $scope.dealDealerHand = ->
    $http
      url: '/blackjack/deal_dealer_hand'
      method: 'POST'
      data: {}
    .success (data) ->
      $scope.dealerHand = data
      $scope.currentHandIndex = null
      $scope.midRound = false
      $scope.bank = data.bank
      $scope.moneyInPlay = 0
      $scope.roundNumber++

  $scope.stand = ->
    $http
      url: '/blackjack/stand'
      method: 'POST'
      data: {}
    .success (data) ->
      $scope.currentHandIndex++

  $scope.hit = ->
    $http 
      url: '/blackjack/hit_me'
      method: 'POST'
      data: {}
    .success (data) ->
      $scope.playerHands[$scope.currentHandIndex] = data

  $scope.createSplit = ->
    $http
      url: '/blackjack/split'
      method: 'POST'
      data: {}
    .success (data) ->
      $scope.playerHands[$scope.currentHandIndex] = data[0]
      $scope.playerHands.splice($scope.currentHandIndex + 1, 0, data[1])

  $scope.currentHand = ->
    if $scope.playerHands[$scope.currentHandIndex]?
      $scope.playerHands[$scope.currentHandIndex].cards
    else
      null
  
  $scope.notBusted = ->
    $scope.currentScore() < 21

  $scope.eligibleToSplit = ->
    if $scope.midRound && $scope.currentHand()?
      cards = $scope.currentHand()
      cards.length == 2 && BlackjackRules.getCardValue(cards[0]) == BlackjackRules.getCardValue(cards[1])
    else
      false

  $scope.updateName = ->
    $http
      url: '/users/update_name'
      method: 'PUT'
      data: 
        name: $scope.user.userName
    .success (data) ->
      $scope.setName = true
      $scope.currentUser.name = data.name
    .error (data) ->
      $scope.user.userName = undefined
      alert('update failed, try again')

  $scope.currentScore = ->
    if $scope.midRound && $scope.currentHand()
      score = BlackjackRules.getHandScore($scope.currentHand())
      score
    else
      null

  $scope.user = (user) ->
    $scope.currentUser = user
    $scope.setName = true if $scope.currentUser.name?

  $scope.startGame = ->
    $scope.gameStarted = true
    $scope.roundNumber = 1
    $scope.fetchHands()

  $scope.fetchHands = ->
    $http 
      url: '/blackjack/start_round'
      method: 'post'
      data:
        wager: $scope.wager
    .success (data) ->
      $scope.playerHands = [data.player_hand]
      $scope.currentHandIndex = 0
      $scope.dealerHand = data.dealer_hand
      $scope.midRound = true

  $scope.requestMoney = ->
    $http
      url: '/blackjack/request_money'
      method: 'post'
      data: 
        request: $scope.requestAmount
    .success (data) ->
      $scope.requestAmount = 0
      $scope.currentUser.money_in_play = data.money_in_play
      $scope.currentUser.bank = data.bank
      $scope.gameStarted = true
      $scope.wager = $scope.currentUser.wager_amount
    .error (data) ->
      alert('You have insufficient funds, scumbag')
