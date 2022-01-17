require 'generic_server.rb'
require 'store.rb'

# Basic SMTP server

class SMTPServer < GenericServer
  attr_accessor :client_data
  
  # Create new server listening on port 25
  def initialize(port)
    self.client_data = Hash.new
    super(:port => port)
  end
  
  # Send a greeting to client
  def greet(client)
    respond(client, 220)
  end
  
  # Process command
  def process(client, command, full_data)
    case command
      when 'DATA' then data(client)
      when 'HELO', 'EHLO' then respond(client, 250)
      when 'NOOP' then respond(client, 250)
      when 'MAIL' then mail_from(client, full_data)
      when 'QUIT' then quit(client)
      when 'RCPT' then rcpt_to(client, full_data)
      when 'RSET' then rset(client)
      when 'AUTH' then auth(client)
      else begin
        if get_client_data(client, :sending_data)
          append_data(client, full_data)
        else
          respond(client, 500)
        end
      end
    end
  end
  
  # Closes connection
  def quit(client)
    respond(client, 221)
    client.close
  end
  
  # Stores sender address
  def mail_from(client, full_data)
    if /^MAIL FROM:/ =~ full_data.upcase
      set_client_data(client, :from, full_data.gsub(/^MAIL FROM:\s*/i,"").gsub(/[\r\n]/,""))
      respond(client, 250)
    else
      respond(client, 500)
    end
  end
  
  # Stores recepient address
  def rcpt_to(client, full_data)
    if /^RCPT TO:/ =~ full_data.upcase
      set_client_data(client, :to, full_data.gsub(/^RCPT TO:\s*/i,"").gsub(/[\r\n]/,""))
      respond(client, 250)
    else
      respond(client, 500)
    end
  end
  
  # Markes client sending data
  def data(client)
    set_client_data(client, :sending_data, true)
    set_client_data(client, :data, "")
    respond(client, 354)
  end
  
  # Resets local client store
  def rset(client)
    self.client_data[client.object_id] = Hash.new
  end
  
  # Authenticates client
  def auth(client)
    respond(client, 235)
  end

  # Adds full_data to incoming mail message
  #
  # We'll store the mail when full_data == "."
  def append_data(client, full_data)
    if full_data.gsub(/[\r\n]/,"") == "."
      Store.instance.add(
        get_client_data(client, :from).to_s,
        get_client_data(client, :to).to_s,
        get_client_data(client, :data).to_s
      )
      respond(client, 250)
      $log.info "Received mail from #{get_client_data(client, :from).to_s} with recipient #{get_client_data(client, :to).to_s}"
    else
      self.client_data[client.object_id][:data] << full_data
    end
  end
  
  protected
  
  # Store key value combination for this client
  def set_client_data(client, key, value)
    self.client_data[client.object_id] = Hash.new unless self.client_data.include?(client.object_id)
    self.client_data[client.object_id][key] = value
  end
  
  # Retreive key from local client store
  def get_client_data(client, key)
    self.client_data[client.object_id][key] if self.client_data.include?(client.object_id)
  end
  
  # Respond to client using a standard SMTP response code
  def respond(client, code)
    super(client, "#{code} #{SMTPServer::RESPONSES[code].to_s}\r\n")
  end
  
  # Standard SMTP response codes
  RESPONSES = {
    500 => "Syntax error, command unrecognized",
    501 => "Syntax error in parameters or arguments",
    502 => "Command not implemented",
    503 => "Bad sequence of commands",
    504 => "Command parameter not implemented",
    211 => "System status, or system help respond",
    214 => "Help message",
    220 => "Bluerail Post Office Service ready",
    221 => "Bluerail Post Office Service closing transmission channel",
    235 => "Authentication successful",
    421 => "Bluerail Post Office Service not available,",
    250 => "Requested mail action okay, completed",
    251 => "User not local; will forward to <forward-path>",
    450 => "Requested mail action not taken: mailbox unavailable",
    550 => "Requested action not taken: mailbox unavailable",
    451 => "Requested action aborted: error in processing",
    551 => "User not local; please try <forward-path>",
    452 => "Requested action not taken: insufficient system storage",
    552 => "Requested mail action aborted: exceeded storage allocation",
    553 => "Requested action not taken: mailbox name not allowed",
    354 => "Start mail input; end with <CRLF>.<CRLF>",
    554 => "Transaction failed"
  }.freeze
end
