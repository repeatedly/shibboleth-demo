# -*- coding: utf-8 -*-

require 'open-uri'
require 'rexml/document'
require 'rexml/formatters/pretty'

class MainController < Ramaze::Controller
  layout :default
  engine :Etanni
  helper :cgi

  def index
    @title   = 'Shibboleth attribute'
    @caption = 'Following table shows user and Shibboleth information.'
    @user    = {}
    @other   = {}

    prefix = 'HTTP_' # Why add 'HTTP_'? Because ShibUseHeaders add 'HTTP_' to request headers.
                     # Probably you can cut this process if you use CGI and FastCGI.
    ShibbolethDemo.options.user.each_pair do |key, value|
      @user[key] = request.env[prefix + value.upcase]
    end

    shib_prefix = prefix + 'SHIB'
    request.env.each_pair do |key, value|
      @other[key[5..-1]] = value if key[0..8] == shib_prefix
    end
  end

  def metadata
    @title   = 'Metadata'
    @caption = 'Following metadata provided by Service Provider.'
    @data    = get_data_from_shib(@title)
    @name    = 'metadata xml'  
  end

  def status
    @title   = 'Status'
    @caption = 'Following XML represents current status of Service Provider.'
    @data    = get_data_from_shib(@title)
    @name    = 'current status'  
  end
  alias_view 'status', 'metadata'

  def login
    config = ShibbolethDemo.options.login

    # User was successful Shibboleth authentication when user reached this point.
    # So, Shibbolize application doesn't have to check password.
    if config.registered.include?(request.env['HTTP_' + config.attribute.upcase])
      @title   = 'Login success'
      @caption = 'You are registered user.'

      # Usually, redirect user to application home.
    else
      @title   = 'Login failure'
      @caption = 'You are un-registered user.'

      # Or auto register like Moodle here.
    end
  end

  private

  def get_data_from_shib(path)
    format(open('http://localhost/Shibboleth.sso/' + path) { |f| f.read })
  rescue
    'Access failed.'
  end

  def format(result)
    xml = ''
    REXML::Formatters::Pretty.new.write(REXML::Document.new(result), xml)
    xml
  end
end
