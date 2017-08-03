PostOffice mock SMTP/POP3 server
================================

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
    -m, --mailbox                    Use separate mailboxes
    -s, --smtp PORT                  Specify SMTP port to use
    -p, --pop3 PORT                  Specify POP3 port to use
    
    -h, --help                       Display this screen

This starts the service and listens on the specified ports (or 25 for SMTP and 110 for POP3 by default). Configure your POP3 client with any username and password.

Config
------

Post Office will try to find a configuration file (post_office/config.json) in the user dir ($HOME), and then in /etc. It will load the first one it finds.

The arguments passed on the command line will always override the ones specified in the config file. 

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

Distinct Mailboxes
------------------

By default, sent emails are broadcast to all clients connected to the POP3 server. To simulate delivery to specific email addresses, use the `--mailbox` setting. 

When connecting to the POP3 server with the mailbox setting enabled, set the `username` field  to the desired email address. 

Planned features
----------------

* Store mail in tempfiles instead of in-memory array

Contributions are welcome! Feel free to fork and send a pull request through Github.

## Changelog

### 1.0.0 (Aug 11, 2016)

* [(tijn)](https://github.com/tijn) [load a config file and move default options (to become more DRY)](https://github.com/bluerail/post_office/pull/5)
* [(gamecreature)](https://github.com/gamecreature) [NOOP smtp command support](https://github.com/bluerail/post_office/pull/4)
* [(martijn)](https://github.com/martijn) Shorten timestamp in logs

### 0.3.3 (Sep 13, 2011)

* [(sgeorgi)](https://github.com/sgeorgi) [Specifying SMTP and POP3 ports on the command line](https://github.com/bluerail/post_office/pull/2)

### 0.3.2 (Sep 13, 2011)

Broken build

### 0.3.1 (Aug 16, 2011)

* First 'official' release
