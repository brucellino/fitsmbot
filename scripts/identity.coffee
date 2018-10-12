# Description:
#   This script gives the robot some identity by setting facts
#   in its brain.
#
# Dependencies:
#   hubot-redis-brain
#
# Configuration:
#   REDIS_URL needs to be set in common.env
#
#   HUBOT_GITHUB_TOKEN needs to be set in secrets.env
#
# Commands:
#   hubot make an improvement - open an issue against the repo to ask the
#   maintainers to improve the bot.
#   This doesn't work yet :)
#
#   hubot categories - should get back the json of categories from the discussion forum
#
# Notes:
#   This script is about the bot itself - it's identity and self-improvement
#   It's important to know who you are, after all - but it's far more important
#   to listen the advice that others who care about you give you.
#
#   People wanting to contribute to the betterment of the bot should be able
#   to discuss it (on the forum), and talk about the bot's issues.
#
# Author:
#   @brucellino
module.exports = (robot) ->

  owner = 'EGI-Foundation'
  repo = 'fitsmbot'

  robot.brain.set 'name', "Fitty I.T. McMaster"
  robot.brain.set 'alias', "FitBot"
  robot.brain.set 'author', "@brucellino"
  robot.brain.set 'description', "A bot who knows FitSM kung-fu"
  robot.respond /report(.*)/i, (res) ->
    issue_text = res.match[1]
    console.log "github token is" + process.env.HUBOT_GITHUB_TOKEN
  
  # be nice
  no_stress = [
    "sure!",
    "sure thing",
    "no stress",
    "don't mention it",
    "all in a day's work",
     "any time buddy"]
  robot.hear /thanks/i, (res) ->
    res.send res.random no_stress
  robot.respond /not you.*/i, (res) ->
    res.reply "my bad :bow:"
    
  robot.respond /categories/i, (res) ->
    robot.http(process.env.DISCOURSE_API_URL + '/categories.json').get() (err, response, body) ->
      if err
        res.send "Encountered an error :( #{err}"
        return
    res.reply body

  robot.respond /do you have any issues.*/i, (res) ->
    # get the issues
    robot.http(process.env.GITHUB_API + '/repos/' + owner + '/' + repo + '/issues')
