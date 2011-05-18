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

    sudo post_office [options]
    
    -v, --verbose                    Output more information
    -l, --logfile FILE               Write log to FILE. Outputs to STDOUT (or /var/log/post_office.log when daemonized) by default.
    -h, --help                       Display this screen

This starts the service and listens on port 25 and 110. Configure your POP3 client with any username and password.

Daemon
------

It's possible to start PostOffice as a daemon using post_officed:

    Usage: post_officed <command> <options> -- <application options>

    * where <command> is one of:
      start         start an instance of the application
      stop          stop all instances of the application
      restart       stop all instances and restart them afterwards
      reload        send a SIGHUP to all instances of the application
      run           start the application and stay on top
      zap           set the application to a stopped state
      status        show status (PID) of application instances

    * and where <options> may contain several of the following:

        -t, --ontop                      Stay on top (does not daemonize)
        -f, --force                      Force operation
        -n, --no_wait                    Do not wait for processes to stop

    Common options:
        -h, --help                       Show this message
            --version                    Show version

Mac OS X Startup Item
---------------------

PostOffice daemon can be started on Mac OS X system startup.

    sudo post_office [options]

    --install-osx-startup-item   Installs Post Office as OS X Startup Item
    --remove-osx-startup-item    Removes Post Office as OS X Startup Item

The Startup Item is stored in */Library/StartupItems/PostOffice*

Planned features
----------------

* Ability to use custom ports for SMTP and POP
* Growl notifications
* Store mail in tempfiles instead of in-memory array

Contributions are welcome! Feel free to fork and send a pull request through Github.
