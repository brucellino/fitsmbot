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

module.exports = (robot) ->
  robot.respond /(hi|hello|bonjour|buongiorno|ciao|salut|sup|hey|yo)/i, (msg) ->
    greetings = [
      "howdy :face_with_cowboy_hat:",
      "yo",
      "hey",
      "hi :wave:",
      "hey",
      "hidyho",
      "hey buuuuudy"
    ]
    msg.reply msg.random greetings
