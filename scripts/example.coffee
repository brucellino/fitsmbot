# Description:
#   This is the basic script for a few generic interactions.
#   It just allows hubot to participate in the conversation
#   in some humourous ways.
#
# Dependencies:
#   none
#
# Configuration:
#   none
#
# Commands:
#   there are no commands here, just hubot joining the conversation.
#
# Notes:
#   Just something to get started with
#
# Author:
#   @brucellino

{ WebClient } = require "@slack/client"

module.exports = (robot) ->
  web = new WebClient robot.adapter.options.token
  
  # Could use the giphy api here.
  # https://api.giphy.com/v1/gifs/search?api_key==yoda&limit=1&offset=10&rating=R&lang=en
  robot.hear /(.*)(will try|ll try)(.*)/i, (res) ->
    res.reply "There is no try, there is only do"


  robot.hear /test/i, (res) ->
    web.api.test()
      .then () -> res.send "Your connection to the Slack API is working!"
      .catch (error) -> res.send "Your connection to the Slack API failed :("
  
  robot.hear /(.*)('s|is) cool(.*)/i, (res) ->
    console.log res.message.room
    console.log res.message.id
    reaction = {
      name: "thumbsup",
      channel: res.message.room,
      timestamp: res.message.id
      }
    console.log reaction
    web.reactions.add reaction

  robot.hear /(.*)like(.*)/i, (res) ->
    res.emote "makes a freshly baked #{msg.match[1]}"
  
  robot.hear /badger/i, (res) ->
    if res.message.thread_ts?
      # The incoming message was inside a thread,
      # responding normally will continue the thread
      res.send "Did someone say BADGER?"
    else
      # The incoming message was not inside a thread,
      # so lets respond by creating a new thread
      res.message.thread_ts = res.message.rawMessage.ts
      res.send "Slight digression, we need to talk about these BADGERS"

  robot.error (err, res) ->
    robot.logger.error "DOES NOT COMPUTE"
  
    if res?
      res.reply "DOES NOT COMPUTE"
      res.reply err
  
  # Send details to a room.
  # the expected value of :room is going to vary by adapter,
  # it might be a numeric id, name, token, or some other value
  robot.router.post '/hubot/chatsecrets/:room', (request, response) ->
    room   = request.params.room
    data   = if request.body.payload? then JSON.parse request.body.payload else request.body
    secret = data.secret

    robot.messageRoom room, "I have a secret: #{secret}"

    response.send 'OK'

  # robot.router.post '/hubot/github/:repo', (request, response) ->
  #   room = 'general'
  #   data = if request.body.payload? then JSON.parse request.body.payload else request.body
  #   console.log data

  #   robot.messageRoom room, "message from github for #{request.params.repo} "

  #   robot.send 'OK'
