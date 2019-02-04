# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## v0.0.5

### Changed

- Tagged v0.0.5
- Added prettier
- Prettified the JSON in data/

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