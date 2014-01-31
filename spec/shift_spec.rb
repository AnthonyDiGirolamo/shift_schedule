require 'active_support/all'
require_relative '../lib/shift'

describe '#initialize' do
   it 'should know the current year' do
      s = Shift.new
      s.year.should == 2014
   end
end

describe '.on_point' do
   it 'knows who has two shifts' do
      people = %W[mitch bill chris robert tony suzanne simpson]
      slots = %W[monday_morning monday_afternoon tuesday_morning tuesday_afternoon wednesday_morning wednesday_afternoon thursday_morning thursday_afternoon friday_morning friday_afternoon]
      preferred_slots = people.zip([5, 3, 8, 6, 1, 4, 2])
      s = Shift.new people: people, slots: slots, preferred_slots: preferred_slots
      s.on_point(0).should == %W[mitch bill chris]
      s.on_point(1).should == %W[bill chris robert]
      s.on_point(2).should == %W[chris robert tony]
   end
end

describe '.schedule' do
   it 'returns who is on shift this week' do
      people = %W[mitch bill chris robert tony suzanne simpson]
      slots = %W[monday_morning monday_afternoon tuesday_morning tuesday_afternoon wednesday_morning wednesday_afternoon thursday_morning thursday_afternoon friday_morning friday_afternoon]
      preferred_slots = people.zip([5, 3, 8, 6, 1, 4, 2])
      s = Shift.new people: people, slots: slots, preferred_slots: preferred_slots

      s.schedule(0).should == ["chris", "tony", "simpson", "bill", "suzanne", "mitch", "robert", "mitch", "chris", "bill"]

   end
end

describe '.rotating_shifts' do
  it 'returns shifts that are rotated amongst people' do
      people = %W[mitch bill chris robert tony suzanne simpson]
      slots = %W[monday_morning monday_afternoon tuesday_morning tuesday_afternoon wednesday_morning wednesday_afternoon thursday_morning thursday_afternoon friday_morning friday_afternoon]
      preferred_slots = people.zip([5, 3, 7, 6, 1, 4, 2])
      s = Shift.new people: people, slots: slots, preferred_slots: preferred_slots

      s.rotating_shifts.should == [0, 8, 9]
  end
end
