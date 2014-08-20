app = angular.module 'gamerec', ['firebase', 'ngCookies']

class UserSvc
    constructor: (@$q, @$log, @$cookies, @$firebase, @$firebaseSimpleLogin) ->
        @fireRef = new Firebase "https://gamerec.firebaseio.com/users"
        @fireSync = @$firebase @fireRef
        @authClient = @$firebaseSimpleLogin @fireRef
        @user = null

        return

    hasLoginId: =>
        return @$cookies.loginId?

    loginSuccess: (user) =>
        @$log.log "Logged in as: #{user.uid}"
        @fireSync.$set user.uid, user
        @$cookies.loginId = user.uid

        return user

    loginFailure: (error) =>
        @$log.log "Login failed: #{error}"

        return

    login: =>
        if @hasLoginId()
            ref = new Firebase "https://gamerec.firebaseio.com/users/#{@$cookies.loginId}"
            promise = @$firebase(ref).$asObject(@$cookies.loginId).$$conf.promise
        else
            promise = @authClient
                .$login "facebook"
                .then @loginSuccess, @loginFailure

        return promise

    logout: =>
        @authClient.$logout()
        @user = null
        delete @$cookies['loginId']

        return

class LoginCtrl
    constructor: (@$scope, @userSvc) ->
        @bindScope()
        @login() if @userSvc.hasLoginId()

        return

    bindScope: ->
        @$scope.login = @login
        @$scope.logout = @logout

        return

    login: =>
        @userSvc.login().then (user) =>
            @$scope.user = user
            return

        return

    logout: =>
        @userSvc.logout()
        @$scope.user = null

class NewGameCtrl
    constructor: (@$scope, @$log, @$firebase) ->
        @fireRef = new Firebase "https://gamerec.firebaseio.com/gamesplayed"
        @fireSync = @$firebase @fireRef
        @$scope.saveGame = @saveGame
        return

    saveGame: (game) =>
        @$log.log "Not Implemented!"
        @fireSync.$set game.name, game

        return

UserSvcFactory = ($q, $log, $cookies, $firebase, $firebaseSimpleLogin) ->
    return new UserSvc $q, $log, $cookies, $firebase, $firebaseSimpleLogin

app.controller "newGameCtrl", [
    "$scope",
    "$log",
    "$firebase",
    NewGameCtrl
]

app.controller "loginCtrl", [
    "$scope",
    "userSvc"
    LoginCtrl
]

app.factory "userSvc", [
    "$q",
    "$log",
    "$cookies",
    "$firebase",
    "$firebaseSimpleLogin",
    UserSvcFactory
]
