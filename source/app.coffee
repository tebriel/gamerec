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
            @user = @$firebase(ref).$asObject(@$cookies.loginId)
            promise = @user.$$conf.promise
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
    constructor: (@$scope, @$log, @$firebase, @userSvc) ->
        @$scope.saveGame = @saveGame
        @$scope.game = {}
        @initForm()
        return

    initForm: =>
        if @$scope.game.datePlayed?
            @$scope.game = datePlayed: @$scope.game.datePlayed
        else
            @$scope.game = datePlayed: moment().format('YYYY-MM-DD')

        return

    saveGame: (game) =>
        @fireRef = new Firebase "https://gamerec.firebaseio.com/gamesplayed/#{@userSvc.user.uid}"
        @fireSync = @$firebase @fireRef
        @fireSync.$push game
            .then @initForm

        return

UserSvcFactory = ($q, $log, $cookies, $firebase, $firebaseSimpleLogin) ->
    return new UserSvc $q, $log, $cookies, $firebase, $firebaseSimpleLogin

app.controller "newGameCtrl", [
    "$scope",
    "$log",
    "$firebase",
    "userSvc",
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
