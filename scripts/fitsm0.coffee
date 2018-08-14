# Scripts for FitSM-0
# This will help people learn and remember the vocabulary and terms of the
# FitSM standard

{WebClient} = require "@slack/client"

module.exports = (robot) ->
  # robot.brain.set 'name', "Fitty I.T. McMaster"
  # robot.brain.set 'alias', "FitBot"
  # robot.brain.set 'author', "Bruce.Becker@egi.eu"
  # robot.brain.set 'description', "A bot who knows FitSM kung-fu"
  web = new WebClient robot.adapter.options.token
  # console.log process.cwd()
  terms_file = process.cwd() + '/data/fitsm-0-terms-and-definitions.json'
  parts_file = process.cwd() + '/data/fitsm-parts.json'
  process_model_file = process.cwd() + '/data/fitsm-process-model.json'
  general_requirements_file = process.cwd() + '/data/fitsm-general-requirements.json'
  process_requirements_file = process.cwd() + '/data/fitsm-process-requirements.json'
  
  fitsm_terms = require terms_file
  fitsm_parts = require parts_file
  fitsm_processes_model = require process_model_file
  fitsm_general_requirements = require general_requirements_file
  fitsm_process_requirements = require process_requirements_file
  
  robot.respond /help fitsm/i, (res) ->
    res.send "Hi :wave: I am #{robot.brain.get('name')}, but you can call me #{robot.brain.get('alias')}"
    res.send "I was written by #{robot.brain.get('author')}, who called me #{robot.brain.get('description')}"
    res.send "I know fitsm! Ask me about FitSM, the fittest of all ITSM standards."
    res.send '#general' , "I know #{fitsm_terms['terms'].length} terms, #{fitsm_parts['parts'].length} parts, #{fitsm_general_requirements['requirements'].length} general requirements and process-specific requirements for #{fitsm_process_requirements['requirements'].length} processes."
    res.send "I also know the FitSM process model - ask me about processes or entities"
  

  
  # I can define fitsm
  robot.respond /what is fitsm/i, (res) ->
    res.reply "FitSM is a lightweight family of standards for IT Service Management"
  
  # I know the parts of the standard.
  robot.hear /what are the fitsm parts/i, (res) ->
    res.reply fitsm_parts

  # I know about it's terms
  robot.hear /what (is|are) the fitsm (terms|vocab|vocabulary|defined terms)/i , (res) ->
    res.reply term.name for term in terms

  robot.respond /define fitsm (.*)/i, (res) ->
    terms = fitsm_terms.terms
    termRequested = res.match[1]
    console.log "#{termRequested} definition requested"
    names = terms.map (t) -> t.name.toLowerCase()
    console.log names
    if termRequested in names
      console.log "found #{termRequested} in terms"
      # get the matching object by term name
      # foundTerm = (term for term in terms when term.name == termRequested)
      foundTerm = (x for x in terms when x.name.toLowerCase() == termRequested)
      console.log foundTerm[0]
      console.log "found #{foundTerm[0].name} - described as #{foundTerm[0].description}"
      res.reply "FitSM defines #{termRequested} as : " + foundTerm[0].description
    else
      res.reply "Sorry, I don't know about that."
      res.reply "Try using something like \"fitsm define <fitsm term>\""
      res.reply "Protip: you can get all the terms by asking me what the terms or vocabulary are."