angular.module('blackjack').controller 'BlackjackCtrl', ($scope, $http) ->

  $scope.currentHand = null
  $scope.roundNumber = 0
  $scope.baseWager = 30
  $scope.bank = 0
  $scope.playerCount = 1
  $scope.playerPreferences = {}



  $scope.readyToPlay = ->
    $scope.roundNumber == 0
    $scope.bank > 0
    $scope.baseWager <= $scope.bank


  $scope.startGame = ->
    if $scope.readyToPlay()
      $scope.fetchHand()
      $scope.roundNumber = 1

  $scope.requestMoney = ->
    $http
      url: '/api/blackjack/request_money'
      method: 'post'
      data: 
        request: $scope.requestAmount
    .success (data) ->
      $scope.requestAmount = 0
      $scope.bank = data
    .error (data) ->
      alert('You have insufficient funds, scumbag')
