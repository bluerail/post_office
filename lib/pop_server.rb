require 'generic_server.rb'
require 'store.rb'
require 'digest/md5'

# Basic POP server

class POPServer < GenericServer
  # Create new server listening on port 110
  def initialize(port)
    @clients = {}
    super(port: port)
  end

  # Send a greeting to client
  def greet(client)
    # # truncate messages for this session
    # # @tvdw - moved this to user method!
    # Store.instance.truncate

    respond(client, true, 'Hello there')
  end

  # Process command
  def process(client, command, full_data)
    address = @clients[client].nil? ? nil : @clients[client]
    nr = message_number(full_data, address)
    case command
    when 'CAPA' then capa(client)
    when 'DELE' then dele(client, nr, address)
    when 'LIST' then list(client, nr, address)
    when 'NOOP' then respond(client, true, 'Yup.')
    when 'PASS' then pass(client, full_data)
    when 'QUIT' then quit(client)
    when 'RETR' then retr(client, nr, address)
    when 'RSET' then respond(client, true, 'Resurrected.')
    when 'STAT' then stat(client, address)
    when 'TOP'  then top(client, full_data, address)
    when 'UIDL' then uidl(client, nr, address)
    when 'USER' then user(client, full_data)
    else respond(client, false, 'Invalid command.')
    end
    # $log.info "POP Mailbox #{Store.instance.messages}"
  end

  # Show the client what we can do
  def capa(client)
    respond(client, true, "Here's what I can do:\r\n" \
                          "USER\r\n" \
                          "IMPLEMENTATION Bluerail Post Office POP3 Server\r\n" \
                          '.')
  end

  # Accepts username
  def user(client, full_data)
    @clients[client] = full_data.match(/USER (.*)/)[1].chomp if Store.instance.mailbox

    # truncate messages for this session
    # @tvdw - Moved truncate from greet, because at that point we do not know which client to truncate yet.
    Store.instance.truncate(@clients[client])

    respond(client, true, 'Password required.')
  end

  # Authenticates client
  def pass(client, _full_data)
    respond(client, true, 'Logged in.')
  end

  # Shows list of messages
  #
  # When a message id is specified only list
  # the size of that message
  def list(client, message, address)
    if message == :invalid
      respond(client, false, 'Invalid message number.')
    elsif message == :all
      messages = ''
      Store.instance.get(address).each.with_index do |msg, index|
        size = msg.nil? ? 0 : msg.size
        messages << "#{index + 1} #{size}\r\n"
      end
      respond(client, true, "POP3 clients that break here, they violate STD53.\r\n#{messages}.")
    else
      message_data = Store.instance.get(address)[message - 1]
      respond(client, true, "#{message} #{message_data.size}")
    end
  end

  # Retreives message
  def retr(client, message, address)
    if message == :invalid
      respond(client, false, 'Invalid message number.')
    elsif message == :all
      respond(client, false, 'Invalid message number.')
    else
      message_data = Store.instance.get(address)[message - 1]
      respond(client, true, "#{message_data.size} octets to follow.\r\n" + message_data + "\r\n.")
    end
  end

  # Shows list of message uid
  #
  # When a message id is specified only list
  # the uid of that message
  def uidl(client, message, address)
    if message == :invalid
      respond(client, false, 'Invalid message number.')
    elsif message == :all
      messages = ''
      Store.instance.get(address).each.with_index do |msg, index|
        messages << "#{index + 1} #{message_uid(msg)}\r\n"
      end
      respond(client, true, "unique-id listing follows.\r\n#{messages}.")
    else
      message_data = Store.instance.get(address)[message - 1]
      respond(client, true, "#{message} #{message_uid(message_data)}")
    end
  end

  # Shows total number of messages and size
  def stat(client, address)
    messages = Store.instance.get(address)

    total_size = messages.collect do |m|
      m.nil? ? 0 : m.size
    end.inject(0) { |sum, x| sum + x }
    respond(client, true, "#{messages.length} #{total_size}")
  end

  # Display headers of message
  def top(client, full_data, address)
    full_data = full_data.split(/TOP\s(\d*)/)
    messagenum = full_data[1].to_i
    number_of_lines = full_data[2].to_i

    messages = Store.instance.get(address)
    if messages.length >= messagenum && messagenum > 0
      headers = ''
      line_number = -2
      messages[messagenum - 1].split(/\r\n/).each do |line|
        line_number += 1 if line.gsub(/\r\n/, '') == '' || line_number > -2
        headers += "#{line}\r\n" if line_number < number_of_lines
      end
      respond(client, true, "headers follow.\r\n" + headers + "\r\n.")
    else
      respond(client, false, 'Invalid message number.')
    end
  end

  # Quits
  def quit(client)
    respond(client, true, 'Better luck next time.')
    @clients.delete(client)
    client.close
  end

  # Deletes message
  def dele(client, message, address)
    if message == :invalid
      respond(client, false, 'Invalid message number.')
    elsif message == :all
      respond(client, false, 'Invalid message number.')
    else
      Store.instance.remove(message - 1, address)
      respond(client, true, 'Message deleted.')
    end
  end

  protected

  # Returns message number parsed from full_data:
  #
  # * No message number => :all
  # * Message does not exists => :invalid
  # * valid message number => some fixnum
  def message_number(full_data, address)
    if /\w*\s*\d/ =~ full_data
      messagenum = full_data.gsub(/\D/, '').to_i
      messages = Store.instance.get(address)
      if messages.length >= messagenum && messagenum > 0
        return messagenum
      else
        return :invalid
      end
    else
      return :all
    end
  end

  # Respond to client with a POP3 prefix (+OK or -ERR)
  def respond(client, status, message)
    super(client, "#{status ? '+OK' : '-ERR'} #{message}\r\n")
  end

  def message_uid(message)
    Digest::MD5.hexdigest(message)
  end
end
