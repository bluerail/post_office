# A really simple SMTP client to test post_office.
# It sends mail, print the mail ObjectID and then delete it.
#
# To use run: `ruby pop_client.rb "address@domain.com"`
require 'mail'

Mail.defaults do
  delivery_method :smtp, address: 'localhost', port: 2525
end
subject = ARGV[2].nil? ? 'test email' : ARGV[2]
from = ARGV[1].nil? ? 'from@address.com' : ARGV[1]
to = ARGV[0].nil? ? 'to@address.com' : ARGV[0]
Mail.deliver do
  from from
  to to
  subject subject
end
