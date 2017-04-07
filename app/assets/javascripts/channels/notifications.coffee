App.notifications = App.cable.subscriptions.create "NotificationsChannel",
  connected: ->
    # Called when the subscription is ready for use on the server

  disconnected: ->
    # Called when the subscription has been terminated by the server

  received: (data) ->
    # Called when there's incoming data on the websocket for this channel
    $('#events').prepend "#{data.event}"
    this.update_counter(data.number)

   update_counter: (counter) ->
     $counter = $('#notification_count')
     $counter
     .css({opacity: 0})
     .text(counter)
     .css({top: '-10px'})
     .transition({top: '-2px', opacity: 1})
