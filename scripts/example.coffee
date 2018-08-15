# Description:
#   Example scripts for you to examine and try out.
#
# Notes:
#   They are commented out by default, because most of them are pretty silly and
#   wouldn't be useful and amusing enough for day to day huboting.
#   Uncomment the ones you want to try and experiment with.
#
#   These are from the scripting documentation:
# https://github.com/github/hubot/blob/master/docs/scripting.md
{ WebClient } = require "@slack/client"

module.exports = (robot) ->
  web = new WebClient robot.adapter.options.token
  
  robot.hear /(will try|ll try)/i, (res) ->
    res.reply "There is no try, there is only do"

  robot.hear /test/i, (res) ->
    web.api.test()
      .then () -> res.send "Your connection to the Slack API is working!"
      .catch (error) -> res.send "Your connection to the Slack API failed :("
  
  robot.hear /that('s|is) cool/i, (res) ->
    console.log res.message.room
    console.log res.message.id
    reaction = { name: "thumbsup", channel: res.message.room, timestamp: res.message.id}
    console.log reaction
    web.reactions.add reaction

  robot.hear /badger/i, (res) ->
    if res.message.thread_ts?
      # The incoming message was inside a thread, responding normally will continue the thread
      res.send "Did someone say BADGER?"
    else
      # The incoming message was not inside a thread, so lets respond by creating a new thread
      res.message.thread_ts = res.message.rawMessage.ts
      res.send "Slight digression, we need to talk about these BADGERS"
  # robot.hear /badger/i, (res) ->
  #   res.send "Badgers? BADGERS? WE DON'T NEED NO STINKIN BADGERS"
  
  # robot.respond /open the (.*) doors/i, (res) ->
  #   doorType = res.match[1]
  #   if doorType is "pod bay"
  #     res.reply "I'm afraid I can't let you do that."
  #   else
  #     res.reply "Opening #{doorType} doors"
  
  # robot.hear /I like pie/i, (res) ->
  #   res.emote "makes a freshly baked pie"
  
  # lulz = ['lol', 'rofl', 'lmao']
  
  # robot.respond /lulz/i, (res) ->
  #   res.send res.random lulz
  
  # robot.topic (res) ->
  #   res.send "#{res.message.text}? That's a Paddlin'"
  
  # enterReplies = ['Hi', 'Target Acquired', 'Firing', 'Hello friend.', 'Gotcha', 'I see you']
  # leaveReplies = ['Are you still there?', 'Target lost', 'Searching']
  
  # robot.enter (res) ->
  #   res.send res.random enterReplies
  # robot.leave (res) ->
  #   res.send res.random leaveReplies
  
  # answer = process.env.HUBOT_ANSWER_TO_THE_ULTIMATE_QUESTION_OF_LIFE_THE_UNIVERSE_AND_EVERYTHING
  
  # robot.respond /what is the answer to the ultimate question of life/, (res) ->
  #   unless answer?
  #     res.send "Missing HUBOT_ANSWER_TO_THE_ULTIMATE_QUESTION_OF_LIFE_THE_UNIVERSE_AND_EVERYTHING in environment: please set and try again"
  #     return
  #   res.send "#{answer}, but what is the question?"
  
  # robot.respond /you are a little slow/, (res) ->
  #   setTimeout () ->
  #     res.send "Who you calling 'slow'?"
  #   , 60 * 1000
  
  # annoyIntervalId = null
  
  # robot.respond /annoy me/, (res) ->
  #   if annoyIntervalId
  #     res.send "AAAAAAAAAAAEEEEEEEEEEEEEEEEEEEEEEEEIIIIIIIIHHHHHHHHHH"
  #     return
  
  #   res.send "Hey, want to hear the most annoying sound in the world?"
  #   annoyIntervalId = setInterval () ->
  #     res.send "AAAAAAAAAAAEEEEEEEEEEEEEEEEEEEEEEEEIIIIIIIIHHHHHHHHHH"
  #   , 1000
  
  # robot.respond /unannoy me/, (res) ->
  #   if annoyIntervalId
  #     res.send "GUYS, GUYS, GUYS!"
  #     clearInterval(annoyIntervalId)
  #     annoyIntervalId = null
  #   else
  #     res.send "Not annoying you right now, am I?"
  
  
  robot.router.post '/hubot/chatsecrets/:room', (req, res) ->
    room   = req.params.room
    data   = JSON.parse req.body.payload
    secret = data.secret
  
    robot.messageRoom room, "I have a secret: #{secret}"
  
    res.send 'OK'
  
  robot.error (err, res) ->
    robot.logger.error "DOES NOT COMPUTE"
  
    if res?
      res.reply "DOES NOT COMPUTE"
      res.reply err
  
  # robot.respond /have a soda/i, (res) ->
  #   # Get number of sodas had (coerced to a number).
  #   sodasHad = robot.brain.get('totalSodas') * 1 or 0
  
  #   if sodasHad > 4
  #     res.reply "I'm too fizzy.."
  
  #   else
  #     res.reply 'Sure!'
  
  #     robot.brain.set 'totalSodas', sodasHad+1
  
  # robot.respond /sleep it off/i, (res) ->
  #   robot.brain.set 'totalSodas', 0
  #   res.reply 'zzzzz'

  # the expected value of :room is going to vary by adapter, it might be a numeric id, name, token, or some other value
  robot.router.post '/hubot/chatsecrets/:room', (request, response) ->
    room   = request.params.room
    data   = if request.body.payload? then JSON.parse request.body.payload else request.body
    secret = data.secret

    robot.messageRoom room, "I have a secret: #{secret}"

    response.send 'OK'

  robot.router.post '/hubot/github/:repo', (request, response) ->
    room = 'general'
    data = if request.body.payload? then JSON.parse request.body.payload else request.body
    console.log data

    robot.messageRoom room, "message from github for #{request.params.repo} "

    robot.send 'OK'