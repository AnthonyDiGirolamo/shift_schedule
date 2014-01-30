#!/usr/bin/env ruby
require 'sinatra'
require 'active_support/all'

get '/' do
  year = 2014
  @start = Date.new(year,1,1).end_of_week
  @end = Date.new(year+1,1,1).end_of_week
  @weeks = ((@end - @start) / 7.0).to_i
  @people = %W[mitch bill chris robert tony suzanne simpson]
  @slots = %W[monday_morning monday_afternoon tuesday_morning tuesday_afternoon wednesday_morning wednesday_afternoon thursday_morning thursday_afternoon friday_morning friday_afternoon]
  @prefered_slots = @people.zip([5, 3, 8, 6, 1, 4, 2])
  erb :'index.html', :layout => :'layout.html'
end
