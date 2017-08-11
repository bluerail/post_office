# A really simple POP client to test post_office.
# It POPs mail, print the mail ObjectID and then delete it.
#
# To use run: `ruby pop_client.rb "address@domain.com"`

require 'net/pop'

Net::POP3.start('localhost', ARGV[1], ARGV[0], 'boguspassword') do |pop|
  unless pop.mails.empty?
    pop.each_mail do |mail|
      p mail
      mail.delete
    end
  end
end
