#!/usr/bin/env ruby
require 'sinatra'
require 'active_support/all'
require_relative 'lib/shift'


def calculate_shifts
  @shift = Shift.new people: @people, slots: @slots, preferred_slots: @preferred_slots

  @shift_counts = {}
  @shift_counts["empty"] = 0
  @people.each do |person|
    @shift_counts[person] = 0
  end

  @shifts = []

  for week in 0..(@weeks-1)
    @shifts[week] = {dates: [], schedule: @shift.schedule(week)}

    for day in [1,2,3,4,5]
      @shifts[week][:dates] << (@start + (week*7).days + day.days).strftime("%A - %m/%d/%Y")
    end

    @shifts[week][:schedule].each do |person|
      @shift_counts[person] += 1
    end
  end
end

before do
  @slots = %W[monday_morning monday_afternoon tuesday_morning tuesday_afternoon wednesday_morning wednesday_afternoon thursday_morning thursday_afternoon friday_morning friday_afternoon].collect{|s| s.titleize}
end

post '/' do
  # logger.info params

  @year = params.fetch("year", Time.new.year).to_i
  @start = Date.new(@year,1,1).end_of_week
  @weeks = params.fetch("weeks", 56).to_i
  @end = @start + (@weeks * 7).days

  @people = params["slot"]["name"].values.reject{|i| i.blank?}
  logger.info @people
  @preferred_slots = params["slot"]["name"].collect{|slot_id, name| [name, slot_id.to_i] unless name.blank? }.compact
  logger.info @preferred_slots
  @people_slots = params["slot"]["name"].values

  calculate_shifts

  erb :'index.html', :layout => :'layout.html'
end

get '/' do
  @year = Time.new.year
  @start = Date.new(@year,1,1).end_of_week
  @end = Date.new(@year+1,1,1).end_of_week
  @weeks = ((@end - @start) / 7.0).to_i
  @people = %W[mitch bill chris simpson tony suzanne robert].collect{|n| n.titleize}
  logger.info @people
  @preferred_slots = @people.zip([5, 3, 7, 6, 1, 4, 2])
  logger.info @preferred_slots
  @people_slots = ["", "mitch", "bill", "chris", "simpson", "tony", "suzanne", "robert", "", ""]

  calculate_shifts

  erb :'index.html', :layout => :'layout.html'
end

