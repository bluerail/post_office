require 'fileutils'
require 'singleton'

# Message storage

class Store
  include Singleton
  attr_accessor :messages
  
  def initialize
    self.messages = []
  end

  # Returns array of messages
  def get
    return messages
  end
  
  # Saves message in storage
  def add(mail_from, rcpt_to, message_data)
    messages.push message_data
  end
  
  # Removes message from storage
  def remove(index)
    self.messages[index] = nil
  end
  
  # Remove empty messages
  def truncate
    self.messages = self.messages.reject{ |message| message.nil? }
  end
end