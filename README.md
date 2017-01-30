# README

This is a step by step guide for how to create a chat application
with Rails ActionCable

* #### Step 1

Make a new rails app as follows:

```
rails new actioncable_test
```

* #### Step 2

Create a model named Message 

```
rails g model message content:text
```

* #### step 3

Create rooms_controller with the view for room with all the messages.
Check the file **app/controllers/rooms_controller.rb**
and view files i.e. **app/views/rooms/show.html.erb**
and for rendering the messages created a partial **app/views/messages/_message.html.erb**

* #### step 4

create a channel named `room` with 1 custom function `speak` as follows:

```
rails g channel room speak
```
It's going to create the following files:
```
app/channels/room_channel.rb
app/assets/javascripts/cable.js
app/assets/javascripts/channels/room.coffee
```

The files would look as follows:
**app/channels/room_channel.rb**
```
class RoomChannel < ApplicationCable::Channel
  def subscribed
    # stream_from "some_channel"
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end

  def speak
  end
end
```
**app/assets/javascripts/cable.js**
```
// Action Cable provides the framework to deal with WebSockets in Rails.
// You can generate new channels where WebSocket features live using the rails generate channel command.
//
//= require action_cable
//= require_self
//= require_tree ./channels

(function() {
  this.App || (this.App = {});

  App.cable = ActionCable.createConsumer();

}).call(this);
```
**app/assets/javascripts/channels/room.coffee**
```
App.test = App.cable.subscriptions.create "TestChannel",
  connected: ->
    # Called when the subscription is ready for use on the server

  disconnected: ->
    # Called when the subscription has been terminated by the server

  received: (data) ->
    # Called when there's incoming data on the websocket for this channel

  speak: ->
    @perform 'speak'
```

* #### step 5

Change the files as follows:

**app/channels/room_channel.rb**
```
class RoomChannel < ApplicationCable::Channel
  def subscribed
    stream_from "room_channel"
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end

  def speak(data)
    Message.create(content: data['message'])
  end
end
```
**app/assets/javascripts/channels/room.coffee**
```
App.room = App.cable.subscriptions.create "RoomChannel",
  connected: ->
    # Called when the subscription is ready for use on the server

  disconnected: ->
    # Called when the subscription has been terminated by the server

  received: (data) ->
    # Called when there's incoming data on the websocket for this channel
    $('#messages').append data['message']

  speak: (message)->
    @perform 'speak', message: message

$(document).on 'keypress', '[data-behavior=room_speaker]', (event) ->
  if event.keyCode is 13
    App.room.speak event.target.value
    event.target.value = ''
    event.preventDefault()
```


##### With these steps your chat app would be ready

But if you want to broadcast a message from outside your server
in development environment you need to [install **Redis**](https://www.digitalocean.com/community/tutorials/how-to-install-and-configure-redis-on-ubuntu-16-04)
and change the **cable.yml** file

from:
```
development:
  adapter: async

test:
  adapter: async

production:
  adapter: redis
  url: redis://localhost:6379/1
```
to:
```
development:
  adapter: redis

test:
  adapter: async

production:
  adapter: redis
  url: redis://localhost:6379/1
```

_For the video version of this [check this out](https://www.youtube.com/watch?v=n0WUjGkDFS0)_