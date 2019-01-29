# Description:
#   This script gives the robot some identity by setting facts
#   in its brain.
#
# Dependencies:
#   hubot-redis-brain
#
# Configuration:
#   DISCOURSE_API_URL - the url of the discourse REST API
#   typically https://community.egi.eu
#   Found in common.env
#
# Commands:
#   fitsm_bot categories -
#         should get back the json of categories from the discussion forum
#
# Notes:
#   People wanting to contribute to the betterment of the bot should be able
#   to discuss it (on the forum), and talk about the bot's issues.
#
# Author:
#   @brucellino
module.exports = (robot) ->
  robot.respond /.*(many).*(categories)/i, (res) ->
  # Say how many categories there are on the forum
    url = "#{process.env.DISCOURSE_API_URL}" + "/categories.json"
    robot.http(url)
      .get() (err, response, body) ->
        if err
          res.send "Encountered an error :( #{err}"
          return
        console.log(body)
        data = JSON.parse body
        console.log(data.category_list.categories.length)
        n = data.category_list.categories.length
        res.reply "There are #{n} categories on
          #{process.env.DISCOURSE_API_URL}"
  

  
