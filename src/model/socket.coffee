io_client = require('socket.io-client')
_ = require("underscore")
Invisible = require('../invisible')

if !Invisible.isClient()
    io = require('socket.io').listen(Invisible.server)
    Invisible.io = io
    io.set('log level', 1)

module.exports = (InvisibleModel) ->

    modelName = InvisibleModel.modelName

    localUrl = if window? then window.location.hostname else "localhost"
    InvisibleModel.socket = io_client.connect("#{localUrl}/#{modelName}")

    if !Invisible.isClient()
        InvisibleModel.serverSocket = io.of("/#{modelName}")

    InvisibleModel.onNew = (cb) ->
        InvisibleModel.socket.on 'new', (data) ->
            model = new InvisibleModel()
            _.extend(model, data)
            cb(model)

    InvisibleModel.onUpdate = (cb) ->
        InvisibleModel.socket.on 'update', (data) ->
            model = new InvisibleModel()
            _.extend(model, data)
            cb(model)

    InvisibleModel.onDelete = (cb) ->
        InvisibleModel.socket.on 'delete', (data) ->
            model = new InvisibleModel()
            _.extend(model, data)
            cb(model)