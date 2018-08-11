require "@slack/client"

module.exports = (robot) ->

  console.log process.cwd()
  terms_file = process.cwd() + '/data/fitsm-0-terms-and-definitions.json'
  parts_file = process.cwd() + '/data/fitsm-parts.json'
  fitsm_terms = require terms_file
  console.log fitsm_terms
  robot.respond /what is fitsm/i, (res) ->
    res.reply "FitSM is a lightweight family of standards for IT Service Management"
    
