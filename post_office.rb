require 'thread'
require 'lib/smtp_server.rb'
require 'lib/pop_server.rb'

begin
  smtp_server = Thread.new{ SMTPServer.new }
  pop_server  = Thread.new{ POPServer.new  }

  smtp_server.join
  pop_server.join
rescue Interrupt
  puts "Interrupt..."
rescue Errno::EACCES
  puts "I need root access to open ports 25 and 110. Please sudo #{__FILE__}"
end