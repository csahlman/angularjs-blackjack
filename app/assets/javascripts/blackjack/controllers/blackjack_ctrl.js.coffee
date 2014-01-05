angular.module('blackjack').controller 'BlackjackCtrl', ($scope, $http, BlackjackRules,
  $timeout) ->

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
  $scope.blackjack = false
  $scope.counter = 7
  timeoutTimer = null
  $scope.showDealerHand = false
  $scope.nextHandTimer = null

  $scope.$watch 'currentHandIndex', (newVal) ->
    if $scope.midRound && (newVal + 1) > $scope.playerHands.length
      $scope.ceaseAction = true
      if $scope.showDealerHand 
        $scope.dealDealerHand(true) 
      else
        $scope.dealDealerHand(false)
      $scope.countDown()
      $scope.nextHandTimer = $timeout($scope.nextHand, 6000)
    else if $scope.midRound 
      $scope.currentHandIndex++ if $scope.currentScore() >= 21

  $scope.countDown = ->
    timeoutTimer = $timeout($scope.countDown, 1000)
    $scope.counter--

  $scope.nextHand = ->
    $timeout.cancel($scope.nextHandTimer)
    $timeout.cancel(timeoutTimer)
    $scope.showDealerHand = false
    $scope.counter = 7
    $scope.ceaseAction = false
    $scope.dealerHand = null
    $scope.midRound = false
    $scope.currentHandIndex = 0
    $scope.playerHands = []
    $scope.roundNumber++
    $scope.blackjack = false
    $scope.fetchHands()

  $scope.updateBank = ->
    $http
      url: '/blackjack/current_bank'
      method: 'get'
    .success (data) ->
      $scope.bank = data.bank

  $scope.dealDealerHand = (alterView) ->
    $http
      url: '/blackjack/deal_dealer_hand'
      method: 'POST'
      data: {
        deal: alterView
      }
    .success (data) ->
      $scope.dealerHand = data unless data.leave_cards_unaltered
      $scope.bank = data.bank


  $scope.stand = ->
    $http
      url: '/blackjack/stand'
      method: 'POST'
      data: {}
    .success (data) ->
      $scope.showDealerHand = true
      $scope.currentHandIndex++

  $scope.hit = ->
    $http 
      url: '/blackjack/hit_me'
      method: 'POST'
      data: {}
    .success (data) ->
      $scope.playerHands[$scope.currentHandIndex] = data
      $scope.showDealerHand = true if $scope.currentScore() == 21
      $scope.currentHandIndex++ if $scope.currentScore() >= 21

  $scope.doubleDown = ->
    $http 
      url: '/blackjack/double_down'
      method: 'post'
      data: {}
    .success (data) ->
      $scope.playerHands[$scope.currentHandIndex] = data
      $scope.showDealerHand = true unless $scope.currentScore() > 21
      $scope.currentHandIndex++

  $scope.split = ->
    $http
      url: '/blackjack/split'
      method: 'POST'
      data: {}
    .success (data) ->
      $scope.playerHands[$scope.currentHandIndex] = data[0]
      $scope.playerHands.splice($scope.currentHandIndex + 1, 0, data[1])
      $scope.currentHandIndex++ if $scope.currentScore() == 21
      # $scope.$apply()

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

  $scope.eligibleToDouble = ->
    $scope.currentHand() != null && $scope.currentHand().length == 2

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

  $scope.currentBoard = (hand) ->
    if $scope.currentHand() && $scope.currentHand() == hand.cards
      true
    else
      false

  $scope.user = (user) ->
    $scope.currentUser = user
    $scope.bank = user.bank
    $scope.setName = true if $scope.currentUser.name?
    $scope.startGame()

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
      $scope.blackjack = data.blackjack
      $scope.dealerHand = data.dealer_hand
      $scope.currentHandIndex = 0
      $scope.midRound = true
      if $scope.dealerHand.blackjack
        $scope.ceaseAction = true 
        $scope.showDealerHand = true
        $scope.dealDealerHand(true)
        $scope.currentHandIndex++
      else
        $scope.bank = data.bank
        $scope.currentHandIndex++ if $scope.currentScore() >= 21


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
