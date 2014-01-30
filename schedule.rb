#!/usr/bin/env ruby
require 'sinatra'
require 'active_support/all'

get '/' do
  year = 2014
  @start = Date.new(year,1,1).end_of_week
  @end = Date.new(year+1,1,1).end_of_week
  erb :'index.html', :layout => :'layout.html'
end
