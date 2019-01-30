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
  web = new WebClient robot.adapter.options.token if robot.adappter == 'slack'
  
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

  robot.hear /(.+) like (.+)/i, (res) ->
    name = res.message.user.name
    thing = res.match[2]
    console.log name
    console.log thing
    res.emote "makes #{name} a freshly baked #{thing}"
  
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
