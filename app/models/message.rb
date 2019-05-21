class Message < ApplicationRecord
  after_create_commit { MessageBroadcastJob.perform_later self }  
  after_update_commit { MessageBroadcastJob.perform_later self }  
  after_destroy       { MessageBroadcastJob.perform_later self }   
end
