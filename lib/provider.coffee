exec = require 'child_process'
fs = require 'fs'
path = require 'path'

module.exports =
  # This will work on JavaScript and CoffeeScript files, but not in js comments.
  selector: '.source.php'
  disableForSelector: '.source.php .comment'
  # keyword.operator.class.php

  # This will take priority over the default provider, which has a priority of 0.
  # `excludeLowerPriority` will suppress any providers with a lower priority
  # i.e. The default provider will be suppressed
  inclusionPriority: 1
  excludeLowerPriority: true

  # Load Completions from json
  loadCompletions: ->
    @completions = {}
    fs.readFile path.resolve(__dirname, '..', 'completions.json'), (error, content) =>
      @completions = JSON.parse(content) unless error?
      return



  # Required: Return a promise, an array of suggestions, or null.
  # {editor, bufferPosition, scopeDescriptor, prefix}
  getSuggestions: (request) ->
    new Promise (resolve) =>
      # if @lastTimeEx? and Math.floor((new Date() - @lastTimeEx) / 60000) < 1
      #   typeEx = false
      # else
      #   typeEx = true

      if @notShowAutocomplete(request)
        resolve([])
      else
        resolve(@getCompletions(request))

  # (optional): called _after_ the suggestion `replacementPrefix` is replaced
  # by the suggestion `text` in the buffer
  onDidInsertSuggestion: ({editor, triggerPosition, suggestion}) ->

  # (optional): called when your provider needs to be cleaned up. Unsubscribe
  # from things, kill any processes, etc.
  dispose: ->

  notShowAutocomplete: (request) ->
    return true if request.prefix.length < 2

  getCompletions: ({editor, prefix}) ->
    completions = []

    for keyword in @completions.keywords when keyword.text.toLowerCase().indexOf(prefix.toLowerCase()) > -1
      completions.push(@buildCompletion(keyword))

    completions

  buildCompletion: (suggestion) ->
    text: suggestion.text
    type: suggestion.type
    displayText: suggestion.displayText ?= null
    snippet: suggestion.snippet ?= null
    leftLabel: suggestion.leftLabel ?= null
    description: suggestion.description ?= "PHP <#{suggestion.text}> #{suggestion.type}"
    descriptionMoreURL: suggestion.text ?= null
