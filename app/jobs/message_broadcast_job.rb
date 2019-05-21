class MessageBroadcastJob < ApplicationJob
  queue_as :default

  def perform(message)
    ActionCable.server.broadcast 'message_channel', item: render(message)  
  end

  private
    def render(message)
      ApplicationController.renderer.render(partial: 'messages/message', locals: {message: message})  
    end

end