# -*- coding: utf-8 -*-

class MainController < Ramaze::Controller
  layout :default
  engine :Etanni

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
end
