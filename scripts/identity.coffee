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
# Commands:
#   hubot make an improvement - open an issue against the repo to ask the
#   maintainers to improve the bot.
#   This doesn't work yet :)
#
#   hubot categories -
#         should get back the json of categories from the discussion forum
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

  # reset knowledge of who has thanked it and how many times.
  robot.brain.set 'been_thanked', {}

  # be nice
  no_stress = [
    "sure!",
    "sure thing",
    "no stress",
    "don't mention it",
    "all in a day's work",
    "any time buddy",
    "Ah fagheddabouddit" ]
  robot.hear /thank(s| you)/i, (res) ->
    thanked_times = robot.brain.get('been_thanked')
    res.message.user.id
    
    res.send res.random no_stress
  robot.respond /not you\s?/i, (res) ->
    res.reply "my bad :bow:"

  robot.respond /who are you/i, (res) ->
    res.reply "My name is #{robot.brain.get('name')},\
    but you can call me #{robot.brain.get('alias')}"