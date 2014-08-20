app = angular.module 'gamerec', ['firebase']

class UserSvc
    constructor: (@$log, @$firebase, @$firebaseSimpleLogin) ->
        @fireRef = new Firebase "https://gamerec.firebaseio.com/users"
        @fireSync = @$firebase @fireRef
        @authClient = @$firebaseSimpleLogin @fireRef
        @user = null

        return

    loginSuccess: (user) =>
        @$log.log "Logged in as: #{user.uid}"
        @fireSync.$set user.uid, user
        #@$scope.user = user

        return user

    loginFailure: (error) =>
        @$log.log "Login failed: #{error}"
        # @$scope.user = null

        return


    login: =>
        promise = @authClient
            .$login "facebook"
            .then @loginSuccess, @loginFailure

        return promise

    logout: =>
        @authClient.$logout()
        @user = null

        return

class LoginCtrl
    constructor: (@$scope, @userSvc) ->
        @bindScope()

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

UserSvcFactory = ($log, $firebase, $firebaseSimpleLogin) ->
    return new UserSvc $log, $firebase, $firebaseSimpleLogin

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
    "$log",
    "$firebase",
    "$firebaseSimpleLogin",
    UserSvcFactory
]
