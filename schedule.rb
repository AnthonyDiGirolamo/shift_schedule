#!/usr/bin/env ruby
require 'sinatra'
require 'active_support/all'

get '/' do
  year = 2014
  @start = Date.new(year,1,1).end_of_week
  @end = Date.new(year+1,1,1).end_of_week
  @weeks = ((@end - @start) / 7.0).to_i
  erb :'index.html', :layout => :'layout.html'
end
