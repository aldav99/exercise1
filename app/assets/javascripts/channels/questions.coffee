cable = ->
  App.cable.subscriptions.create('QuestionsChannel', {
    connected: ->
      @perform 'follow'
    ,

    received: (data) ->
      $("tbody").append data
  })

$(document).on('turbolinks:load', cable)