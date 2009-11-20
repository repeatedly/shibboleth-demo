# About

This application provides Shibboleth test site.

## Require

* Ruby 1.8 (1.9 not support bacause Rack has bug)
* Ramaze

# Action

* index

  Show the user and Shibboleth informaion.

* metadata

  Show metadata of Service Provider.

# Apache configuration

## Debian

  Allow require modules.

    $ sudo a2enmod proxy proxy_http headers

  Put following code to site configuration (e.g. site-enabled/shibboleth)

    <Location /Shibboleth>
        AuthType shibboleth
        ShibRequireSession On
        ShibUseHeaders On
        require valid-user
    </Location>

    <Proxy http://127.0.0.1:7000/>
           Order deny,allow
           Allow from all
    </Proxy>

    RequestHeader set X_FORWARDED_PROTO 'https'
    ProxyPass /Shibboleth/ http://127.0.0.1:7000/
    ProxyPassReverse /Shibboleth/ http://127.0.0.1:7000/

  Run ramaze (-D option means daemonize).

    $ ramaze start -D

# Copyright

    Copyright (c) 2009 Masahiro Nakagawa

This application is released under the Ruby license.
