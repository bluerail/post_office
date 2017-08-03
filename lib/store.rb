require 'fileutils'
require 'singleton'

# Message storage

class Store
  include Singleton
  attr_accessor :messages, :mailbox

  def initialize
    @messages = {}
    @messages[:default] = []
    @mailbox = false
  end

  # Returns array of messages
  def get(key = nil)
    if @mailbox && !key.nil?
      @messages[key] = [] unless @messages[key].is_a?(Array)
      return @messages[key]
    else
      return @messages[:default]
    end
  end

  # Saves message in storage
  def add(_mail_from, rcpt_to, message_data)
    key = rcpt_to.gsub(/[<>]/, '')
    if @mailbox
      @messages[key] = [] unless @messages[key].is_a?(Array)
      @messages[key].push message_data
    else
      @messages[:default].push message_data
    end
  end

  # Removes message from storage
  def remove(index, key = nil)
    if @mailbox && !key.nil?
      @messages[key][index] = nil
    else
      @messages[:default][index] = nil
    end
  end

  # Remove empty messages
  def truncate(key = nil)
    if @mailbox && !key.nil?
      @messages[key] = @messages[key].reject(&:nil?) if @messages[key].is_a?(Array)
    else
      @messages[:default] = @messages[:default].reject(&:nil?)
    end
  end
end
