# Description:
#   This script provides the basis for some deep sayings
#
# Dependencies:
#   hubot-cron
#
# Configuration:
#   none
#
# Commands:
#   hubot just says these things of it's own accord from time to time
#
# Notes:
#   These quotes are attributed to David Carradine, Bruce Lee
#   and Abraham Lincoln
# Author:
#   @brucellino
{ WebClient } = require "@slack/client"
quotes = [
  "If you trust yourself, any choice you make will be correct.
  If you do not trust yourself, anything you do will be wrong.",
  "To know oneself is to study oneself in action with another person.",
  "When one eye is fixed on the destination,
   you have only one eye to search for the way.",
  "When your enemy is weak, you must make him strong. To destroy that enemy,
   you must first glorify his power",
  "There are two strengths...
  the strength of the body and the strength of the spirit.
  The body is the arrow. The spirit is the bow.
  You must learn to use the strength of the spirit",
  "A worker is known by his tools",
  " If a man dwells on the past, then he robs the present.
   But if a man ignores the past, he may rob the future.",
  "Do not pray for an easy life,
   pray for the strength to endure a difficult one.",
  "If you don’t want to slip up tomorrow, speak the truth today.",
  "A goal is not always meant to be reached.
   It often serves simply as something to aim at"
  "Moving… be like water. Still… be like a mirror. Respond like an echo.",
  "I fear not the man who has practiced 10,000 kicks once,
   but I fear the man who has practiced one kick 10,000 times.",
  "A quick temper will make a fool of you soon enough.",
  "Notice that the stiffest tree is most easily cracked,
   while the bamboo or willow survives by bending with the wind.",
  "Obey the principles without being bound by them.",
  "Showing off is the fool’s idea of glory.",
  "Absorb what is useful, discard what is not, add what is uniquely your own.",
  "Knowledge will give you power, but character respect.",
  "Those who are unaware they are walking
   in darkness will never seek the light.",
  "A wise man can learn more from a foolish question
   than a fool can learn from a wise answer.",
  "Choose the positive.
  You have choice, you are master of your attitude,
   choose the positive, the constructive.",
  "I can show you the path but I can not walk it for you.",
  "A Black Belt should be a reflection of what is inside not the proof of it!",
  "He who is taught only by himself has a fool for a master.",
  "The weakest of all weak things is a virtue that has not been tested in the
  fire.",
  "Seek not to follow in the footsteps of men of old; seek what they sought.",
  "We are what we repeatedly do. Excellence then, is not an act, but a habit.",
  "Should you desire the great tranquility, prepare to sweat.",
  "First master your instrument, than just play.",
  " There is no secret ingredient, to make something special
   you just have to believe its special.",
  "If you spend too much time thinking about a thing,
   you'll never get it done.",
  "Knowing is not enough, you must apply; willing is not enough, you must do.",
  "I am not teaching you anything. I just help you to explore yourself",
  "As you think, so shall you become."
  ]

module.exports = (robot) ->
  web = new WebClient robot.adapter.options.token
  # choose a random quote
  n = Math.floor(Math.random() * (quotes.length))

  # get the fitsm channel
  default_channel_name = "fitsm"
  web.channels.list()
    .then (api_response) ->
      # The channel list is searched for the channel with the right name,
      # and the notification_room is updated
      room = api_response.channels.find (channel) ->
        channel.name is default_channel_name
      notification_room = room.id if room?
      robot.messageRoom room.id, quotes[n]
      # NOTE: for workspaces with a large number of channels,
      # this can result in a timeout error. Use pagination.
    .catch (error) ->
      robot.logger.error error.message