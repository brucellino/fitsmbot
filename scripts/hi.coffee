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
  robot.respond /.*hi.*$/i, (msg) ->
    msg.reply('hi :wave:')
