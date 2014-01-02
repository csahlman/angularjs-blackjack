angular.module('blackjack').controller 'BlackjackCtrl', ($scope, $http, BlackjackRules) ->

  $scope.setName = false
  $scope.dealerHand = null
  $scope.playerHands = []
  $scope.user = {}
  $scope.currentHand = null
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
  
  $scope.eligibleToHit = ->
    $scope.currentScore() < 21

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
    score = BlackjackRules.getHandScore($scope.currentHand.cards)
    console.log score
    if isNaN(score)
      return 0
    else
      score

  $scope.user = (user) ->
    $scope.currentUser = user
    $scope.setName = true if $scope.currentUser.name?


  $scope.readyToPlay = ->
    $scope.userName? && 
      $scope.roundNumber == 0 &&
      $scope.bank > 0 &&
      $scope.baseWager <= $scope.bank

  $scope.currentScore = ->
    score = 0
    aces = 0


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
      $scope.currentHand = data.player_hand
      $scope.playerHands = [data.player_hand]
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
