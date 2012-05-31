# Created by 'bundle exec annotate --position before'
# == Schema Information
#
# Table name: meetings
#
#  id              :integer         not null, primary key
#  school_class_id :integer
#  meeting_theme   :string(255)
#  meeting_date    :date
#  meeting_time    :time
#  meeting_room    :string(255)
#  created_at      :datetime        not null
#  updated_at      :datetime        not null
#

require 'spec_helper'

describe Meeting do
  before(:each) do
    @class = FactoryGirl.create( :school_class )
    @attr_meeting = {
      :meeting_theme => 'Text is here',
      :meeting_date => "#{Date.today}",
      :meeting_time => "#{Time.now.strftime("%H:%M")}",
      :meeting_room => '1234'
    }
  end

  describe "Creation" do
    it "should create meeting via class with valid attributes" do
      expect do
        @class.meetings.create( @attr_meeting ).should be_valid
      end.should change( Meeting, :count ).by( 1 )
    end

    it "should reject to create meeting via class with wrong attributes" do
      expect do
        attrs = @attr_meeting.merge( :meeting_theme => ' ' )
        @class.meetings.create( attrs ).should_not be_valid
      end.should_not change( Meeting, :count )
    end
  end

  describe "Meeting associations" do
    before(:each) do
      @meeting = @class.meetings.create( @attr_meeting )
    end

    it "should have school class attribute" do
      @meeting.should respond_to( :school_class )
    end

    it "should have right associated school class" do
      @meeting.school_class_id.should == @class.id
      @meeting.school_class.should == @class
    end
  end

  describe "Validations" do
    describe "Rejection" do
      it "should reject blank meeting's theme" do
        wrong_attr = @attr_meeting.merge( :meeting_theme => "  " )
        @class.meetings.build( wrong_attr ).should_not be_valid
      end

      it "should reject too long meeting's theme" do
        wrong_attr = @attr_meeting.merge( :meeting_theme => "a" * 201 )
        @class.meetings.build( wrong_attr ).should_not be_valid
      end

      it "should reject date of meeting if date < 1 from now" do
        dates = ( Date.today - 5.years )..( Date.today - 2.years )
        dates.each do |d|
          wrong_attr = @attr_meeting.merge( :meeting_date => d )
          @class.meetings.build( wrong_attr ).should_not be_valid
        end
      end

      it "should reject date of meeting if date > 1 from now" do
        dates = ( Date.today + 2.years )..( Date.today + 5.years )
        dates.each do |d|
          wrong_attr = @attr_meeting.merge( :meeting_date => d )
          @class.meetings.build( wrong_attr ).should_not be_valid
        end
      end

      it "should reject blank time" do
        wrong_attr = @attr_meeting.merge( :meeting_time => "" )
        @class.meetings.build( wrong_attr ).should_not be_valid
      end

      it "should reject blank meeting's room" do
        wrong_attr = @attr_meeting.merge( :meeting_room => "  " )
        @class.meetings.build( wrong_attr ).should_not be_valid
      end

      it "should reject too long meeting's room" do
        wrong_attr = @attr_meeting.merge( :meeting_room => "a" * 5 )
        @class.meetings.build( wrong_attr ).should_not be_valid
      end
    end

    describe "Acceptance" do
      it "should accept meetings's theme with correct length" do
        (1..200).each do |i|
          correct_attr = @attr_meeting.merge( :meeting_theme => 'a' * i  )
          @class.meetings.build( correct_attr ).should be_valid
        end
      end

      it "should accept meetings's date if 1 <= date <= 1 years from now" do
        dates = ( Date.today - 1.year )..( Date.today + 1.year )
        dates.each do |d|
          correct_attr = @attr_meeting.merge( :meeting_date => d  )
          @class.meetings.build( correct_attr ).should be_valid
        end
      end

      it "should accept correct meetings's time" do
        correct_attr = @attr_meeting.merge(:meeting_time =>"#{Time.now.strftime("%H:%M")}")
        @class.meetings.build( correct_attr ).should be_valid
      end

      it "should accept meetings's room with correct length" do
        (1..4).each do |i|
          correct_attr = @attr_meeting.merge( :meeting_room => 'a' * i  )
          @class.meetings.build( correct_attr ).should be_valid
        end
      end
    end
  end

  describe "Scopes" do
    describe "fresh_meetings" do
      it "should find future meeting" do
        @new_meeting = @class.meetings.create(
                              @attr_meeting.merge( :meeting_date => Date.today + 1.day ) )
        Meeting.fresh_meetings.first.should == @new_meeting
      end

      it "should find today meeting" do
        @today_meeting = @class.meetings.create(
                                @attr_meeting.merge( :meeting_date => Date.today ) )
        Meeting.fresh_meetings.first.should == @today_meeting
      end

      it "should not find old meeting" do
        @old_meeting = @class.meetings.create(
                              @attr_meeting.merge( :meeting_date => Date.today - 1.day ) )
        Meeting.fresh_meetings.first.should_not == @old_meeting
      end
    end
  end
end
