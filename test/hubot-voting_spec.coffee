# Hubot classes
Robot = require "hubot/src/robot"
Message = require "hubot/src/message"
TextMessage = Message.TextMessage

# process.env.HUBOT_LOG_LEVEL = 'debug'

# Load assertion methods to this scope
path = require 'path'
chai = require 'chai'
nock = require 'nock'
expect = chai.expect

describe 'hubot-voting', ->
  robot = undefined
  user = undefined
  adapter = undefined

  beforeEach (done) ->

    robot = new Robot(null, 'mock-adapter', false, 'hubot')
    robot.adapter.on 'connected', ->
      robot.loadFile path.resolve('.', 'src'), 'hubot-voting.coffee'
      adapter = robot.adapter

      # Creating the fake user
      user = robot.brain.userForId '1', {
        name: 'testuser',
        room: '#mocha'
      }

      do waitForHelp = ->
        if robot.helpCommands().length > 0
          do done
        else
          setTimeout waitForHelp, 100

    do robot.run
    return

  afterEach ->
    robot.shutdown()
    return

  describe 'Help Commands', ->
    it 'should have 5', (done) ->
      expect(robot.helpCommands()).to.have.length 5
      do done

  describe 'successful responds', ->
    it 'should start a single poll', (done) ->
      adapter.on 'send', (envelope, strings) ->
        try
          expect(envelope.user.id).to.equal '1'
          expect(envelope.user.name).to.equal 'testuser'
          expect(envelope.user.room).to.equal '#mocha'
          expect(strings[0]).to.equal "Vote started \n0: test1"
          do done
        catch e
          done e
      adapter.receive new TextMessage user, 'hubot start vote test1'

    it 'should start multiple polls', (done) ->
      adapter.on 'send', (envelope, strings) ->
        try
          expect(envelope.user.id).to.equal '1'
          expect(envelope.user.name).to.equal 'testuser'
          expect(envelope.user.room).to.equal '#mocha'
          expect(strings[0]).to.equal "Vote started \n0: test1\n1: test2"
          do done
        catch e
          done e
      adapter.receive new TextMessage user, 'hubot start vote test1, test2'

    # it 'should respond back that voting is already working', (done) ->
    #   adapter.on 'send', (envelope, strings) ->
    #     try
    #       expect(envelope.user.id).to.equal '1'
    #       expect(envelope.user.name).to.equal 'testuser'
    #       expect(envelope.user.room).to.equal '#mocha'
    #       expect(strings[0]).to.equal "A vote is already underway"
    #     catch e
    #       done e
    #   adapter.receive new TextMessage user, 'hubot start vote test1'
