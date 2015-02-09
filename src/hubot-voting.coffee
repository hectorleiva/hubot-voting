# Description
#   To vote on topics
#
# Dependencies:
#   None
#
# Commands:
#   hubot start vote item1, item2, item3, ...
#   hubot vote for N - where N is the choice number or the choice name
#   hubot show choices
#   hubot show votes - shows current votes
#   hubot end vote
#
# Notes:
#   <optional notes required for the script>
#
# Author:
#   antonishen [joshua@antonishen.com]
#   Hector Leiva [hector@hectorleiva.com]

module.exports = (robot) ->
  robot.voting = {}

  robot.respond /start vote (.+)$/i, (msg) ->

    if robot.voting.votes?
      msg.send "A vote is already underway"
      sendChoices (msg)
    else
      # Reset all the votes
      robot.voting.votes = {}
      # Assign the starter of the vote
      robot.voting.starter = robot.brain.usersForFuzzyName(msg.message.user['name'])[0].name
      # Create the voting choices
      createChoices msg.match[1]
      sendChoices(msg)

  robot.respond /end vote/i, (msg) ->

    if robot.voting.votes?
      if robot.voting.starter == robot.brain.usersForFuzzyName(msg.message.user['name'])[0].name
        endVoting(msg)
      else
        msg.reply "You can not end the vote, only " + robot.voting.starter + " can end the vote."
        return
    else
      msg.send "Voting has not been started"

  robot.respond /show choices/i, (msg) ->
    sendChoices(msg)

  robot.respond /show votes/i, (msg) ->
    results = tallyVotes()
    sendChoices(msg, results)

  robot.respond /vote (for )?(.+)$/i, (msg) ->
    choice = null

    re = /\d{1,2}$/i
    if re.test(msg.match[2])
      choice = parseInt msg.match[2], 10
    else
      choice = robot.voting.choices.indexOf msg.match[2]

    console.log choice

    sender = robot.brain.usersForFuzzyName(msg.message.user['name'])[0].name

    if validChoice choice
      robot.voting.votes[sender] = choice
      msg.send "#{sender} voted for #{robot.voting.choices[choice]}"
    else
      msg.send "#{sender}: That is not a valid choice"

  createChoices = (rawChoices) ->
    robot.voting.choices = rawChoices.split(/, /)

  sendChoices = (msg, results = null) ->

    if robot.voting.choices?
      response = "Vote started \n"
      for choice, index in robot.voting.choices
        response += "#{index}: #{choice}"
        if results?
          response += " -- Total Votes: #{results[index]}"
        response += "\n" unless index == robot.voting.choices.length - 1
    else
      msg.send "There is not a vote going on right now"

    msg.send response

  validChoice = (choice) ->
    numChoices = robot.voting.choices.length - 1
    0 <= choice <= numChoices

  endVoting = (msg) ->
    console.log robot.voting.votes

    results = tallyVotes()

    response = "The results are..."
    for choice, index in robot.voting.choices
      response += "\n#{choice}: #{results[index]}"

    msg.send response

    # Reset all the options
    delete robot.voting.votes
    delete robot.voting.starter
    delete robot.voting.choices

  tallyVotes = () ->
    results = (0 for choice in robot.voting.choices)

    voters = Object.keys robot.voting.votes
    for voter in voters
      choice = robot.voting.votes[voter]
      results[choice] += 1

    results
