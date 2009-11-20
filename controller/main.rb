# -*- coding: utf-8 -*-

require 'net/https'

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
      @other[key] = value if key[0..8] == shib_prefix
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

  private

  def get_data_from_shib(path)
    http = Net::HTTP.new('localhost', '443')
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE
    http.start { |connection|
      connection.get('/Shibboleth.sso/' + path,
                     'Cookie' => cookie_to_str).body
    }
  rescue
    'Access failed.'
  end

  def cookie_to_str
    request.cookies.map do |key, value|
      "#{key}=#{value}"
    end.join(';')
  end
end
