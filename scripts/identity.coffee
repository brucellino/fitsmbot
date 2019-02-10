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

{ WebClient } = require "@slack/client"



module.exports = (robot) ->
  issues_url = process.env.GITHUB_API +
  '/repos/' + process.env.GITHUB_ORG + '/' +
  process.env.GITHUB_SELF_REPO +
  '/issues?state=open'

  web = new WebClient robot.adapter.options.token
  owner = 'EGI-Foundation'
  repo = 'fitsmbot'
  robot.brain.set 'name', "Fitty I.T. McMaster"
  robot.brain.set 'alias', "FitBot"
  robot.brain.set 'author', "@brucellino"
  robot.brain.set 'description', "A bot who knows FitSM kung-fu"
  robot.brain.set 'fitsm_version', "2.4"

  # be nice
  no_stress = [
    "sure!"
    "sure thing"
    "no stress"
    "don't mention it"
    "all in a day's work"
    "any time buddy"
    "Ah fagheddabouddit"
  ]
  # Keep track of who is thanking you and how much.
  # Also respond nicely.
  robot.hear /thank(s| you)/i, (res) ->
    res.send res.random no_stress
  
  robot.respond /not you\s?/i, (res) ->
    res.reply "my bad :bow:"

  robot.respond /who are you/i, (res) ->
    res.reply "My name is #{robot.brain.get('name')}, \
    but you can call me #{robot.brain.get('alias')}"
  
  robot.respond /version/i, (res) ->
    try
      res.reply "#{robot.brain.get 'fitsm_version' }"
    catch error
      res.reply error
      
  # Give some hints on how to make and update suggetions
  robot.hear /help suggestions/i, (res) ->
    res.send "to make a suggestion use
    `#{robot.name} make suggestion: \"<suggestion>\"`"
    res.send "to list all the suggestions use
    `#{robot.name} show suggestionbox`"
  
  # Suggest something to hubot
  robot.respond /make suggestion: "(.*)"$/i, (res) ->
    console.log res.match.length
    suggestion = res.match[1]
    # current suggestions
    s = robot.brain.get('suggestions') or []
    console.log suggestion
    console.log s
    console.log "adding #{suggestion}"
    s.push suggestion
    console.log s
    robot.brain.set 'suggestions', s
    res.reply "Added suggestion \"#{suggestion}\" - there are now
    #{robot.brain.get('suggestions').length} suggestions in the box"

  # sometimes suggestions are silly
  robot.respond /(dismiss|remove) suggestion (\d)/i, (res) ->
    console.log "trying to remove suggestion #{res.match[2]}
    of #{robot.brain.get('suggestions').length}:" +
    robot.brain.get('suggestions')["#{res.match[2]}" - 1]
    if res.match[2] <= robot.brain.get('suggestions').length
      res.reply "removing suggestion
        #{robot.brain.get('suggestions')[res.match[2] - 1]}"
      suggestions = robot.brain.get('suggestions')
      suggestion = robot.brain.get('suggestions')[res.match[2] - 1]
      filtered_suggestions = suggestions.filter (s) -> s != suggestion
      robot.brain.set 'suggestions', filtered_suggestions
      console.log filtered_suggestions
    else
      res.reply "The suggestion you want to remove is not known to me.
      I only have #{robot.brain.get('suggestions').length} suggestions
      in my box"

  # Show what's in the suggestionbox
  robot.respond ///
    (get|how many|show)?\s*
    suggestion(s?)\s*
    (are there\s*)*
    (\s*in the\s*)*
    (box)?
  ///i, (res) ->
    res.reply "getting suggestions..."
    try
      robot.brain.suggestions?
      suggestions = robot.brain.get 'suggestions'
      res.reply "there are #{suggestions.length}
        suggestions in the box:\n" +
        ("#{value + 1}: #{key}\n" for key, value in suggestions)
    catch err
      res.reply "there is a shocking lack of suggestions"
  
  robot.respond /get issues/i, (res) ->
    robot.reply "I don't really like to air my dirty laundry in public,
    but you can see my issues at #{issues_url}"
    console.log issues_url
    console.log process.env.HUBOT_GITHUB_TOKEN
    ts = res.message.id
    ch = res.message.room
    console.log "timestamp is #{ts}, room is #{ch}"
    res.http(issues_url)
    .headers(Authorization: 'token ' + process.env.HUBOT_GITHUB_TOKEN)
    .get() (err, res, body) ->
      issues = JSON.parse body
      atts = [ (
        "fallback": issue.title
        "color": "#36a64f"
        "author_name": issue.user.login
        "author_link": issue.user.html_url
        "author_icon": issue.user.avatar_url
        "title": "#{issue.number} - #{issue.title}"
        "title_link": issue.html_url
        "text": "#{issue.body}"
        # "fields": [
        #   {
        #       "title": "Priority",
        #       "value": "High",
        #       "short": false
        #   }
        #   ],
        "ts": ts
      )  for issue in issues ][0]
      console.log atts
      web.chat.postMessage(
        channel: ch
        text: "Open issues"
        attachments: atts
      )