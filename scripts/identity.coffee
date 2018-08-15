module.exports = (robot) ->

  robot.brain.set 'name', "Fitty I.T. McMaster"
  robot.brain.set 'alias', "FitBot"
  robot.brain.set 'author', "Bruce.Becker@egi.eu"
  robot.brain.set 'description', "A bot who knows FitSM kung-fu"
  console.log "saving the brain"
  
  robot.respond /^.*improvement.*/i, (res) ->
    res.send "I am but a bot - please help me improve by opening a ticket at https://github.com/EGI-Foundation/fitsmbot/issues/new"

  robot.respond /categories/i, (res) ->
    robot.http(process.env.DISCOURSE_API_URL + '/categories.json').get() (err, response, body) ->
    if err
      res.send "Encountered an error :( #{err}"
      return
    res.reply body
