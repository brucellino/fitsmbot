# Description:
#   This script just says hi to whoever says hi to it
#
# Dependencies:
#   none
#
# Configuration:
#   none
#
# Commands:
#   hubot hi - says hi to the robot
#
# Notes:
#   Just something to get started with
#
# Author:
#   @brucellino

regex = ///
  (hi|
  hello|
  bonjour|
  buongiorno|
  ciao|
  salut|
  sup|
  hey|
  yo|
  howdy|
  hidyho)
  ///i

greetings = [
  "howdy :face_with_cowboy_hat:",
  "yo",
  "hey",
  "hi :wave:",
  "hey",
  "hidyho",
  "hey buuuuudy",
  "hello there",
  "🇮🇹 ciao!",
  "🇫🇷 salut!",
  "'ello guvna :tophat:",
  "what's shakin, Alabama?"
  ]
module.exports = (robot) ->
  robot.respond regex, (msg) ->
    msg.reply msg.random greetings
