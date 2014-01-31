require 'active_support/all'
require 'prettyprint'

class Shift
   attr_accessor :year, :people, :slots, :preferred_slots

   def initialize(args = {})
      @year = args.fetch(:year, Time.new.year)
      @people = args.fetch(:people, []).dup
      @slots = args.fetch(:slots, []).dup
      @preferred_slots = args.fetch(:preferred_slots, []).dup
   end

   def rotating_shifts
     slot_numbers = []
     for i in 0..slots.size-1
       slot_numbers << i
     end
     slot_numbers - @preferred_slots.collect{|p,i| i}
   end

   def uncovered_shifts
      slots.size - people.size
   end

   def on_point(week)
      return people.rotate(week)[0,uncovered_shifts]
   end

   def schedule(week)
      for i in 0..uncovered_shifts

         this_weeks_schedule = slots.fill("empty")
         preferred_slots.each do |person, slot|
           this_weeks_schedule[slot] = person
         end

         double_timers = self.on_point(week).rotate(i)
         attempts = double_timers.size

         while this_weeks_schedule.include?("empty") && attempts > 0 do
            empty_slot = this_weeks_schedule.index("empty")
            if double_timers.first != this_weeks_schedule[empty_slot+1] && double_timers.first != this_weeks_schedule[empty_slot-1]
               this_weeks_schedule[empty_slot] = double_timers.shift
            else
               double_timers.rotate
            end
            attempts -= 1
         end
         break unless this_weeks_schedule.include?("empty")
      end

      return this_weeks_schedule
   end
end
