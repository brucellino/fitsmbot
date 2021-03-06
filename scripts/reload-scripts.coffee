# Description:
#   Allows Hubot to (re)load scripts without restart
#
# Commands:
#   hubot reload - Reloads scripts without restart. Loads new scripts too. (a fork version that works perfectly)
#
# Author:
#   spajus
#   vinta
#   m-seldin

Fs       = require 'fs'
Path     = require 'path'

oldCommands = null
oldListeners = null

module.exports = (robot) ->
  # In order to reload the scripts, you need to have the reload role.
  robot.respond /reload/i, id:'reload-scripts.reload',  (msg) ->
    role = 'reload'
    user = robot.brain.userForName(msg.message.user.name)
    return msg.reply "#{name} does not exist" unless user?
    unless robot.auth.hasRole(user, role)
      msg.reply "Access Denied. You need role #{role} to perform this action."
      return
    
    try
      oldCommands = robot.commands
      oldListeners = robot.listeners

      robot.commands = []
      robot.listeners = []

      reloadAllScripts msg, success, (err) ->
        msg.send err
    catch error
      console.log "Hubot reloader:", error
      msg.send "Could not reload all scripts: #{error}"

  success = (msg) ->
    # Cleanup old listeners and help
    for listener in oldListeners
      listener = {}
    oldListeners = null
    oldCommands = null
    query_terms = [
      'clean-slate',
      'reload',
      'reset',
      'restart',
      'start-over',
      'clean-sweep',
      'begin'
    ]
    console.log "there are #{query_terms.length} terms"
    randomIndex = Math.floor Math.random() * (query_terms.length + 1)
    console.log randomIndex
    query = query_terms[randomIndex]
    url = "#{process.env.GIPHY_API_URL}/search?\
    q=#{query}&\
    api_key=#{process.env.GIPHY_API_KEY}&\
    limit=100&\
    rating=pg-13"
    console.log url
    # msg.send "Reloaded all scripts"
    robot.http(url)
        .get() (err, response, body) ->
          if err
            res.send "encountered error #{err}"
            return
          data = JSON.parse(body)
          number = Math.floor( Math.random() * 100)
          console.log(number)
          msg.send data.data[number].images.original.url

  walkSync = (dir, filelist) ->
    #walk through given directory and collect files
    files = Fs.readdirSync(dir)
    filelist = filelist || []
    for file in files
      fullPath = Path.join(dir,file)
      robot.logger.debug "Scanning file : #{fullPath}"

      if (Fs.statSync(fullPath).isDirectory())
        filelist = walkSync(fullPath, filelist)
      else
        #add full path file to returning collection
        filelist.push(fullPath)
    return filelist

  # ref: https://github.com/srobroek/hubot/blob/e543dff46fba9e435a352e6debe5cf210e40f860/src/robot.coffee
  deleteScriptCache = (scriptsBaseDir) ->
    if Fs.existsSync(scriptsBaseDir)
      fileList = walkSync scriptsBaseDir

      for file in fileList.sort()
        robot.logger.debug "file: #{file}"
        if require.cache[require.resolve(file)]
          try
            cacheobj = require.resolve(file)
            console.log "Invalidate require cache for #{cacheobj}"
            delete require.cache[cacheobj]
          catch error
            console.log "Unable to invalidate #{cacheobj}: #{error.stack}"
    robot.logger.debug "Finished deleting script cache!"

  reloadAllScripts = (msg, success, error) ->
    robot = msg.robot
    robot.emit('reload_scripts')

    robot.logger.debug "Deleting script cache..."

    scriptsPath = Path.resolve ".", "scripts"
    deleteScriptCache scriptsPath
    robot.load scriptsPath

    scriptsPath = Path.resolve ".", "src", "scripts"
    deleteScriptCache scriptsPath
    robot.load scriptsPath

    robot.logger.debug "Loading hubot scripts..."

    hubotScripts = Path.resolve ".", "hubot-scripts.json"
    Fs.exists hubotScripts, (exists) ->
      if exists
        Fs.readFile hubotScripts, (err, data) ->
          if data.length > 0
            try
              scripts = JSON.parse data
              scriptsPath = Path.resolve "node_modules", "hubot-scripts", "src", "scripts"
              robot.loadHubotScripts scriptsPath, scripts
            catch err
              error "Error parsing JSON data from hubot-scripts.json: #{err}"
              return

    robot.logger.debug "Loading hubot external scripts..."

    robot.logger.debug "Deleting cache for apppulsemobile"
    deleteScriptCache Path.resolve ".","node_modules","hubot-apppulsemobile","src"

    externalScripts = Path.resolve ".", "external-scripts.json"
    Fs.exists externalScripts, (exists) ->
      if exists
        Fs.readFile externalScripts, (err, data) ->
          if data.length > 0
            try
              robot.logger.debug "DATA : #{data}"
              scripts = JSON.parse data

              if scripts instanceof Array
                for pkg in scripts
                  scriptPath = Path.resolve ".","node_modules",pkg,"src"
                  robot.logger.debug "Deleting cache for #{pkg}"
                  robot.logger.debug "Path : #{scripts}"
                  deleteScriptCache scriptPath
            catch err
              error "Error parsing JSON data from external-scripts.json: #{err}"
            robot.loadExternalScripts scripts
            return
    robot.logger.debug "step 5"

    success(msg)
