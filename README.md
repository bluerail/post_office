PostOffice mock SMTP/POP3 server
================================

https://github.com/bluerail/post_office

By Rene van Lieshout <rene@bluerail.nl>

Description
-----------

PostOffice is a mock SMTP/POP3 server to accept mails sent from your Rails application when it's running in development. The messages can be retrieved using a standard POP3 client, such as mail.app. Just connect to localhost with any username and password.

Note: Received messages are **not** sent to their final recipient and will remain available until deleted or when the process is quit.

Installation
------------

    sudo gem install post_office

Usage
-----

    sudo post_office

This starts the service and listens on port 25 and 110. Configure your POP3 client with any username and password.

Planned features
----------------

* Ability to use custom ports for SMTP and POP
* Growl notifications
* Mac OS X Startup Item / launchctl service
* Store mail in tempfiles instead of in-memory array
* Tests :)

Contributions are welcome! Feel free to fork and send a pull request through Github.
