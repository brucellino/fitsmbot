# Description:
#   Scripts for FitSM-0
#   This will help people learn and remember the vocabulary and terms of the
#   FitSM standard
# Dependencies:
#   none
#
# Configuration:
#   REDIS_URL needs to be set in common.env
#   HUBOT_GITHUB_TOKEN needs to be set in secrets.env
#
# Commands:
#   hubot help : Gives an informative message about what the script does
#   hubot what is fitsm : Gives a definition of fitsm
#   hubot what is/are the fitsm vocabulary/terms : Gives a list of the
#               fitsm defined terms.
#   hubot tell me about the fitsm processes : responds with a message describing
#               all of the processes and how they are organised.
#
# Notes:
#   This script should help novices to FitSM learn about the standard itself.
#
# Author:
#   @brucellino


{WebClient} = require "@slack/client"

module.exports = (robot) ->
  web = new WebClient robot.adapter.options.token
  # console.log process.cwd()
  terms_file = process.cwd() + '/data/fitsm-0-terms-and-definitions.json'
  parts_file = process.cwd() + '/data/fitsm-parts.json'
  process_model_file = process.cwd() + '/data/fitsm-process-model.json'
  general_requirements_file = process.cwd() +
   '/data/fitsm-general-requirements.json'
  process_requirements_file = process.cwd() +
   '/data/fitsm-process-requirements.json'
  
  fitsm_terms = require terms_file
  fitsm_parts = require parts_file
  fitsm_processes_model = require process_model_file
  fitsm_general_requirements = require general_requirements_file
  fitsm_process_requirements = require process_requirements_file
  
  # The process model is quite complex, we'll need some arrays
  # for constructing message attachments later

  robot.respond /help/i, (res) ->
    # could turn this into a message with attachments and formatting
    res.send "Hi :wave: I am #{robot.brain.get('name')},
      but you can call me #{robot.brain.get('alias')}"
    res.send "I was written by #{robot.brain.get('author')},
     who called me #{robot.brain.get('description')}"
    res.send "I know fitsm!
     Ask me about FitSM, the fittest of all ITSM standards."
    res.send "I know #{fitsm_terms['terms'].length} terms,
     #{fitsm_parts['parts'].length} parts,
      #{fitsm_general_requirements['requirements'].length}
       general requirements and process-specific requirements
        for #{fitsm_process_requirements['requirements'].length} processes."
    res.send "I also know the FitSM process model
     - ask me about processes or entities"
  

  
  # I can define fitsm
  robot.respond /what is fitsm/i, (res) ->
    res.reply "FitSM is a lightweight family of standards
     for IT Service Management"
  
  # I know the parts of the standard.
  robot.hear /what are the fitsm parts/i, (res) ->
    res.reply "FitSM #{fitsm_parts.version} is split into
     #{fitsm_parts.parts.length} parts"
    res.reply "#{part.name} - #{part.description}" for part in fitsm_parts.parts

  # I know about it's terms
  robot.hear /what (is|are) the fitsm (terms|vocab|vocabulary|defined terms)/i , (res) ->
    terms = fitsm_terms.terms
    if res.message.thread_ts?
      # The incoming message was inside a thread,
      # responding normally will continue the thread
      res.reply term.name for term in terms
    else
      # The incoming message was not inside a thread,
      # so lets respond by creating a new thread
      res.message.thread_ts = res.message.rawMessage.ts
      res.reply term.name for term in terms

  robot.respond /define fitsm (.*)/i, (res) ->
    terms = fitsm_terms.terms
    termRequested = res.match[1]
    console.log "#{termRequested} definition requested"
    names = terms.map (t) -> t.name.toLowerCase()
    if termRequested in names
      console.log "found #{termRequested} in terms"
      # get the matching object by term name
      # foundTerm = (term for term in terms when term.name == termRequested)
      foundTerm = (x for x in terms when x.name.toLowerCase() == termRequested)[0]
      console.log "found #{foundTerm.name}
       - described as #{foundTerm.description}"
      if foundTerm.notes.length > 0
        notes = ({"title": note.name, "value": note.description} for note in foundTerm.notes)
      else
        notes = []

      console.log "Attachment notes are "
      console.log notes
      console.log "posting message"
      web.chat.postMessage(
        {
          channel: res.message.room,
          text: "FitSM definition for #{termRequested}",
          attachments: [
            {
              fallback: "FitSM defines #{termRequested} as : " + foundTerm.description,
              title: "#{termRequested}",
              text: foundTerm.description,
              fields: notes
            }
          ]
        }
      )
    else
      res.reply "Sorry, I don't know about that."
      res.reply "Try using something like \"define fitsm <fitsm term>\""
      res.reply "Protip: you can get all the terms
       by asking me what the terms or vocabulary are."


  # and its processes
  robot.hear /tell me about the fitsm processes/i, (res) ->
    msg_fields = (({
      "title": process.title, "value": process.name
      } for process in fitsm_processes_model.processes when process.section == i
    ) for i in [0..fitsm_processes_model.sections.length])
    # and put it into the attachments
    for section in [0...fitsm_processes_model.sections.length]
      console.log section
      msg_fields[section] = fitsm_processes_model.sections.filter (section) ->
        fitsm_processes_model.sections.section = section
    console.log msg_fields
    
    msg_attachments = ({
      "fallback": section.name,
      "title": section.title,
      "color": section.colour,
      "text": section.name,
      "fields": msg_fields
      } for section in fitsm_processes_model.sections)

    message = {
      channel: res.message.room,
      text: "there are #{fitsm_processes_model.processes.length} \
             processes, organised into sections:",
      attachments: msg_attachments
    }
    console.log message
    web.chat.postMessage(
      {
        channel: res.message.room,
        text: "there are #{fitsm_processes_model.processes.length}\
         processes, organised into sections:",
        attachments: msg_attachments
      }
    )

# give info about specific processes
    robot.hear /fitsm process (.*)/i, (res) ->
      processes = fitsm_processes_model.processes
      console.log processes
      processRequested = res.match[1]
      console.log "#{processRequested} definition requested"
      names = processes.map (p) -> p.name.toLowerCase()
      if processRequested in names
        console.log "found #{processRequested} in terms"
        # get the matching object by process name
        foundProcess = (x for x in processes when x.name.toLowerCase() == processRequested)[0]
        console.log "found #{foundProcess.name}
         - objective is #{foundProcess.objective}"
        # get inputs and outputs
        console.log "Attachment notes are "
        console.log "posting message"
  
        web.chat.postMessage(
          {
            channel: res.message.room,
            text: "#{foundProcess.title} objective: #{foundProcess.objective}",
          }
        )
      else
        res.reply "Sorry, I don't know about that process."
        res.reply "Try using something like
          \"tell me about fitsm process service portfolio management\""
        res.reply "Try sometihng like what are the fitsm processes"