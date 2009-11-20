# -*- coding: utf-8 -*-

require 'rubygems'
require 'ramaze'
require 'ramaze/spec/bacon'

require __DIR__('../app')

describe MainController do
  behaves_like :rack_test

  should 'show index page' do
    get('/').status.should == 200
    last_response['Content-Type'].should == 'text/html'
    last_response.should =~ /<h2>Shibboleth attribute<\/h2>/
  end

  should 'show metadata page' do
    get('/metadata').status.should == 200
    last_response.should =~ /<h2>Metadata<\/h2>/
  end

  should 'show status page' do
    get('/status').status.should == 200
    last_response.should =~ /<h2>Status<\/h2>/
  end
end
