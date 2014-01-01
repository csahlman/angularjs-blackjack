angular.module('blackjack').controller 'BlackjackCtrl', ($scope, $http) ->

  $scope.setName = false
  $scope.dealerHand = {}
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

  # $scope.$watch('[currentUser.bank, currentUser.money_in_play]', (newVal) ->
  #   console.log newVal
  #   # $scope.$digest()
  # , true)


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

  $scope.user = (user) ->
    $scope.currentUser = user
    $scope.setName = true if $scope.currentUser.name?


  $scope.readyToPlay = ->
    $scope.userName? && 
      $scope.roundNumber == 0 &&
      $scope.bank > 0 &&
      $scope.baseWager <= $scope.bank

  $scope.currentScore = ->

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
      console.log $scope.playerHands
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
