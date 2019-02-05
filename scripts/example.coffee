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
  
  robot.hear /(.*)(will try|ll try)(.*)/i, (res) ->
    url = "#{process.env.GIPHY_API_URL}/search?q=yoda+no+try&api_key=#{process.env.GIPHY_API_KEY}&limit=20"
    console.log(url)
    robot.http(url)
        .get() (err, response, body) ->
          if err
            res.send "encountered error #{err}"
            return
          data = JSON.parse(body)
          number = Math.floor( Math.random() * 20)
          console.log(number)
          res.send data.data[number].images.original.url
        
  robot.hear /test/i, (res) ->
    web.api.test()
      .then () -> res.send "Your connection to the Slack API is working!"
      .catch (error) -> res.send "Your connection to the Slack API failed :("

  # report on whether the environment variables are set up properly.
  robot.hear /env check/i, (res) ->
    res.message.thread_ts = res.message.rawMessage.ts if not res.message.thread_ts?
    res.send "checking environment"
    required_vars = [
      'GITHUB_ORG',
      'GITHUB_APP_NAME',
      'HUBOT_GITHUB_TOKEN',
      'HUBOT_DISCOURSE_API_TOKEN'
    ]
    s = ("process.env.#{k}" for k in required_vars)
    console.log 'process.env."#{GITHUB_APP_NAME}"'
    
  

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

  robot.hear /^(sweet|dude)!/i, (res) ->
    switch res.match[1].toLowerCase()
      when "sweet" then res.send "Dude! 🤙"
      when "dude" then res.send "Sweet! 🤙"
