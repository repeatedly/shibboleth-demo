# -*- coding: utf-8 -*-

# This file contains your application, it requires dependencies and necessary
# parts of the application.
#
# It will be required from either `config.ru` or `start.rb`

require 'rubygems'
require 'ramaze'

# Make sure that Ramaze knows where you are
Ramaze.options.roots = [__DIR__]

module ShibbolethDemo
  include Ramaze::Optioned

  # Please edit following items
  options.dsl do
    sub :federation do
      o 'Federation name', :name,
        'A Federation'

      o 'Federation site', :site,
        'http://example.org/'
    end

    o 'Display user attributes', :user,
      {
        'EduPerson principal name' => 'eppn',
        'Given name'               => 'givenname',
        'Surname'                  => 'sn',
        'Common name'              => 'cn',
        'E-mail'                   => 'mail'
      }

    sub :login do
      # You select unique id (e.g. eppn, mail, uid, etc)
      o 'Attribute for login', :attribute,
        'cn'

      # Test data. In fact, use Database, Directory Service, etc.
      o 'Registered users', :registered,
        ['student', 'teacher', 'stuff']
    end
  end
end

# Initialize modules
require __DIR__('controller/main')
