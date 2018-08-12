require "@slack/client"

module.exports = (robot) ->
  
  console.log process.cwd()
  terms_file = process.cwd() + '/data/fitsm-0-terms-and-definitions.json'
  parts_file = process.cwd() + '/data/fitsm-parts.json'
  fitsm_terms = require terms_file
  console.log fitsm_terms
  robot.messageRoom '#general' , "I know fitsm! Ask me about #{fitsm_terms['terms'].length} terms"

  robot.respond /what is fitsm/i, (res) ->
    res.reply "FitSM is a lightweight family of standards for IT Service Management"
  
  robot.respond /what (is|are) the fitsm (terms|vocab|vocabulary|defined terms)/i , (res) ->
    terms = fitsm_terms['terms']
    # send_term = (term) ->
    res.reply term.name for term in terms
    
