class Message < ApplicationRecord
  after_create_commit { MessageBroadcastJob.perform_later self }

  private

  def broadcast_chat
    ActionCable::server.broadcast 'room_channel', message: content
  end
end
