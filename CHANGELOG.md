# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## v0.1.0

I can now tell you about processes! Listeners have been added to list and describe processes,
bringing this to parity in functionality with the terms.

## Changed

- Added new listeners to list and define processes, from the fitsm process model:
  - `@fitsmbot list processes` - lists all processes
  - `@fitsmbot define process <process title|e.g. SPM>` - show details about the process requested
  - `@fitsmbot (describe) fitsm processes` - gives processes and their sections
  - `@fitsmbot list processes in section <sec>` - list processes in a given section
- closed #12
- slightly reformatted the output of the `get issues` listener

## v0.0.6

A slight cleanup of the code and the ability to get issues from github.

### Changed

- Tagged v0.0.6
- Changed reaction to surfer happiness from a message to a reaction, using the Slack Web API
- Respond with a reload gif when you ask for the scripts to be reloaded
- Be able to get issues with `<robot> get issues`

## v0.0.5

### Changed

- Tagged v0.0.5
- Added prettier
- Prettified the JSON in data/
- Added license description to fitsm JSON files (Closed #15)

## v0.0.4

### Changed

- Tagged v0.0.4
- Added hubot-auth package for role-based authorisation.
- Protected the reload command with the reload role
- Moved reload scripts to the repo so that the command is protected
- Rewrote the regex for responding to greetings.
- Remove the "like --> freshly baked" response. It was a _silly_ place.

## v0.0.3

### Changed

- Tagged v0.0.3
- Included github vars (in github.env and docker-compose.yml)
- Reformatted points.coffee from tabs to spaces

## v0.0.2

### Changed

- Tagged v0.0.2
- We're playing for points.coffee now
- Made the bot sensitive.coffee
- Fixed some linting errors in urban.coffee

## v0.0.1

### Changed

- Added scripts ported in from hubot-scripts.
  - advice: gives some advice on things when you're desperate
  - urban: get definitions from the urban dictionary, when the FitSM vocabulary is not enough.
  - uptime: respond with uptime
  - sweet|dude: Be iry 🏄 🤙
- Made FitSM Channel a variable read via common.env, updated kung-fu script to read it. 
- Environment variables separated into separate parts.
- Changelog added