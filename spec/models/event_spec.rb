# Created by 'bundle exec annotate --position before'
# == Schema Information
#
# Table name: events
#
#  id                   :integer         not null, primary key
#  school_class_id      :integer
#  teacher_id           :integer
#  event_place          :string(255)
#  event_place_of_start :string(255)
#  event_begin_date     :date
#  event_end_date       :date
#  event_begin_time     :time
#  event_end_time       :time
#  event_cost           :integer
#  created_at           :datetime        not null
#  updated_at           :datetime        not null
#

require 'spec_helper'

describe Event do
  before(:each) do
    @teacher = FactoryGirl.create( :teacher )
    @school_class = FactoryGirl.create( :school_class )
    @attr_event = {
      :school_class_id => @school_class.id,
      :teacher_id => @teacher.id,
      :event_place => "Piter",
      :event_place_of_start => "Moscow",
      :event_begin_date => "#{Date.today}",
      :event_end_date => "#{Date.today}",
      :event_begin_time => Time.now.strftime("%H:%M"),
      :event_end_time => Time.now.strftime("%H:%M"),
      :event_cost => "500"
    }
  end

  describe "Creation" do
    it "should create event with valid attributes" do
      expect do
        Event.create( @attr_event ).should be_valid
      end.should change( Event, :count ).by( 1 )
    end

    it "should not count event with invalid attributes" do
      expect do
        Event.create( @attr_event.merge( :event_cost => "" ) ).should_not be_valid
      end.should_not change( Event, :count )
    end
  end

  describe "Event associations" do
    before(:each) do
      @event = Event.create( @attr_event )
    end

    it "should have school class attribute" do
      @event.should respond_to( :school_class )
    end

    it "should have teacher attribute" do
      @event.should respond_to( :teacher )
    end

    it "should have right associated school class" do
      @event.school_class_id.should == @school_class.id
      @event.school_class.should == @school_class
    end

    it "should have right associated teacher" do
      @event.teacher_id.should == @teacher.id
      @event.teacher.should == @teacher
    end
  end

  describe "Validations" do
    describe "Rejection" do
      it "should reject nil school's class" do
        wrong_attr = @attr_event.merge( :school_class_id => nil )
        Event.new( wrong_attr ).should_not be_valid
      end

      it "should reject nil teacher's class" do
        wrong_attr = @attr_event.merge( :teacher_id => nil )
        Event.new( wrong_attr ).should_not be_valid
      end

      it "should reject blank event place" do
        wrong_attr = @attr_event.merge( :event_place => "  " )
        Event.new( wrong_attr ).should_not be_valid
      end

      it "should reject too long event place" do
        wrong_attr = @attr_event.merge( :event_place => "a" * 201 )
        Event.new( wrong_attr ).should_not be_valid
      end

      it "should reject blank event place of start" do
        wrong_attr = @attr_event.merge( :event_place_of_start => "  " )
        Event.new( wrong_attr ).should_not be_valid
      end

      it "should reject too long event place of start" do
        wrong_attr = @attr_event.merge( :event_place_of_start => "a" * 201 )
        Event.new( wrong_attr ).should_not be_valid
      end

      it "should reject begin date if it's < 1 year from nowdays" do
        dates = ( Date.today - 5.years )..( Date.today - 2.years )
        dates.each do |d|
          wrong_attr = @attr_event.merge( :event_begin_date => d )
          Event.new( wrong_attr ).should_not be_valid
        end
      end

      it "should reject begin date if it's > 1 year from nowdays" do
        dates = ( Date.today + 2.years )..( Date.today + 5.years )
        dates.each do |d|
          wrong_attr = @attr_event.merge( :event_begin_date => d )
          Event.new( wrong_attr ).should_not be_valid
        end
      end

      it "should reject end date if it's < 1 year from nowdays" do
        dates = ( Date.today - 5.years )..( Date.today - 2.years )
        dates.each do |d|
          wrong_attr = @attr_event.merge( :event_end_date => d )
          Event.new( wrong_attr ).should_not be_valid
        end
      end

      it "should reject end date if it's > 1 year from nowdays" do
        dates = ( Date.today + 2.years )..( Date.today + 5.years )
        dates.each do |d|
          wrong_attr = @attr_event.merge( :event_end_date => d )
          Event.new( wrong_attr ).should_not be_valid
        end
      end

      it "should reject nil date of begining" do
        wrong_attr = @attr_event.merge( :event_begin_date => nil )
        Event.new( wrong_attr ).should_not be_valid
      end

      it "should reject nil date of end" do
        wrong_attr = @attr_event.merge( :event_end_date => nil )
        Event.new( wrong_attr ).should_not be_valid
      end

      it "should reject empty date of begining" do
        wrong_attr = @attr_event.merge( :event_begin_date => "" )
        Event.new( wrong_attr ).should_not be_valid
      end

      it "should reject empty date of end" do
        wrong_attr = @attr_event.merge( :event_end_date => "" )
        Event.new( wrong_attr ).should_not be_valid
      end

      it "should reject nil date of begining and end" do
        wrong_attr = @attr_event.merge( :event_begin_date => nil, :event_end_date => nil )
        Event.new( wrong_attr ).should_not be_valid
      end

      it "should reject empty date of begining and end" do
        wrong_attr = @attr_event.merge( :event_begin_date => "", :event_end_date => "" )
        Event.new( wrong_attr ).should_not be_valid
      end

      it "should reject if end date < begin date" do
        wrong_attr = @attr_event.merge( :event_begin_date => "#{Date.today}",
                                        :event_end_date => "#{Date.today - 1.year}" )
        Event.new( wrong_attr ).should_not be_valid
      end

      it "should reject nil time of begining" do
        wrong_attr = @attr_event.merge( :event_begin_time => "" )
        Event.new( wrong_attr ).should_not be_valid
      end

      it "should reject blank time of end" do
        wrong_attr = @attr_event.merge( :event_end_time => "" )
        Event.new( wrong_attr ).should_not be_valid
      end

      it "should reject nil time of end" do
        wrong_attr = @attr_event.merge( :event_end_time => nil )
        Event.new( wrong_attr ).should_not be_valid
      end

      it "should reject blank time of begining" do
        wrong_attr = @attr_event.merge( :event_begin_time => nil )
        Event.new( wrong_attr ).should_not be_valid
      end

      it "should reject nil time of begining and end" do
        wrong_attr = @attr_event.merge( :event_begin_time => "", :event_end_time => "" )
        Event.new( wrong_attr ).should_not be_valid
      end

      it "should reject nil time of end and begining" do
        wrong_attr = @attr_event.merge( :event_end_time => nil, :event_begin_time => nil )
        Event.new( wrong_attr ).should_not be_valid
      end

      it "should reject if end time < begin time" do
        wrong_attr = @attr_event.merge( :event_begin_time => Time.now,
                                        :event_end_time => Time.now - 2.hours  )
        Event.new( wrong_attr ).should_not be_valid
      end

      it "should reject blank cost" do
        wrong_attr = @attr_event.merge( :event_cost => "" )
        Event.new( wrong_attr ).should_not be_valid
      end

      it "should reject all symbols except numbers in cost" do
        wrong_attr = @attr_event.merge( :event_cost => "432a" )
        Event.new( wrong_attr ).should_not be_valid
      end

      it "should reject float cost" do
        wrong_attr = @attr_event.merge( :event_cost => "432.1" )
        Event.new( wrong_attr ).should_not be_valid
      end

      it "should reject cost < 0" do
        wrong_attr = @attr_event.merge( :event_cost => "-1" )
        Event.new( wrong_attr ).should_not be_valid
      end

      it "should reject cost >= 100000" do
        (100000..100010).each do |v|
          wrong_attr = @attr_event.merge( :event_cost => v )
          Event.new( wrong_attr ).should_not be_valid
        end
      end
    end

    describe "Acceptance" do
      it "should accept event's place with correct length" do
        (1..200).each do |i|
          correct_attr = @attr_event.merge( :event_place => 'a' * i  )
          Event.new( correct_attr ).should be_valid
        end
      end

      it "should accept event's of start with correct length" do
        (1..200).each do |i|
          correct_attr = @attr_event.merge( :event_place_of_start => 'a' * i  )
          Event.new( correct_attr ).should be_valid
        end
      end

      it "should accept event's begin date if 1 <= date <= 1 years from now" do
        dates = ( Date.today - 1.year )..( Date.today + 1.year )
        dates.each do |d|
          correct_attr = @attr_event.merge( :event_begin_date => d,
                                            :event_end_date => "#{Date.today + 1.year}" ) # We set here maximum possible end date, bacause begin date should <= end date.
          Event.new( correct_attr ).should be_valid
        end
      end

      it "should accept event's end date if 1 <= date <= 1 years from now" do
        dates = ( Date.today - 1.year )..( Date.today + 1.year )
        dates.each do |d|
          correct_attr = @attr_event.merge( :event_end_date => d,
                                            :event_begin_date => "#{Date.today - 1.year}" ) # We set here minimum possible begin date, bacause begin date should <= end date.
          Event.new( correct_attr ).should be_valid
        end
      end

      it "should accept times if begin time <= end time" do
        correct_attr = @attr_event.merge( :event_begin_time => Time.now,
                                          :event_end_time => Time.now + 1.hour  )
        Event.new( correct_attr ).should be_valid
      end

      it "should accept cost >= 0" do
        (0..50).each do |i|
          correct_attr = @attr_event.merge( :event_cost => i  )
          Event.new( correct_attr ).should be_valid
        end
      end
    end
  end

  describe "Scopes" do
    describe "fresh_events" do
      it "should find future event" do
        @new_event = Event.create( @attr_event.merge(
                                        :event_begin_date => Date.today + 1.day,
                                        :event_end_date => Date.today + 1.day ))
        Event.fresh_events.first.should == @new_event
      end

      it "should find today event" do
        @today_event = Event.create( @attr_event.merge(
                                          :event_begin_date => Date.today,
                                          :event_end_date => Date.today  ))
        Event.fresh_events.first.should == @today_event
      end

      it "should not find old events (yesterday, for example)" do
        @ols_event = Event.create( @attr_event.merge(
                                         :event_begin_date => Date.today - 1.day,
                                         :event_end_date => Date.today - 1.day  ))
        Event.fresh_events.should == []
      end
    end
  end
end
