#!/usr/bin/env ruby
require 'sinatra'
require 'active_support/all'
require_relative 'lib/shift'

post '/' do
  logger.info params

  @year = params["year"].to_i
  @start = Date.new(@year,1,1).end_of_week
  @weeks = params["weeks"].to_i
  @end = @start + (@weeks * 7).days
  @slots = %W[monday_morning monday_afternoon tuesday_morning tuesday_afternoon wednesday_morning wednesday_afternoon thursday_morning thursday_afternoon friday_morning friday_afternoon]

  @people = params["person"]["name"].values.reject{|i| i.blank?}

  @preferred_slots = @people.zip( params["person"]["shift"].values[0,@people.size].collect{|i|i.to_i} )

  @shift = Shift.new people: @people, slots: @slots, preferred_slots: @preferred_slots
  erb :'index.html', :layout => :'layout.html'
end

get '/' do
  @year = Time.new.year
  @start = Date.new(@year,1,1).end_of_week
  @end = Date.new(@year+1,1,1).end_of_week
  @weeks = ((@end - @start) / 7.0).to_i
  @people = %W[mitch bill chris robert tony suzanne simpson]
  @slots = %W[monday_morning monday_afternoon tuesday_morning tuesday_afternoon wednesday_morning wednesday_afternoon thursday_morning thursday_afternoon friday_morning friday_afternoon]
  @preferred_slots = @people.zip([5, 3, 7, 6, 1, 4, 2])
  @shift = Shift.new people: @people, slots: @slots, preferred_slots: @preferred_slots

  erb :'index.html', :layout => :'layout.html'
end

