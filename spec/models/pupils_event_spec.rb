# == Schema Information
#
# Table name: pupils_events
#
#  id         :integer         not null, primary key
#  pupil_id   :integer
#  event_id   :integer
#  created_at :datetime        not null
#  updated_at :datetime        not null
#

require 'spec_helper'

describe PupilsEvent do
  before(:each) do
    @pupil = FactoryGirl.create( :pupil )
    @event = FactoryGirl.create( :event )
  end

  describe "PupilsEvent creation" do
    it "should be success" do
      expect do
        PupilsEvent.create( :pupil_id => @pupil.id, :event_id => @event.id )
      end.should change( PupilsEvent, :count ).by( 1 )
    end
  end

  describe "Qualification association" do
    before(:each) do
      @event_p = PupilsEvent.create( :pupil_id => @pupil.id, :event_id => @event.id )
    end

    it "should have a pupil attribute" do
      @event_p.should respond_to( :pupil )
    end

    it "should have a event attribute" do
      @event_p.should respond_to( :event )
    end

    it "should have the right associated pupil" do
      @event_p.pupil_id.should == @pupil.id
      @event_p.pupil.should == @pupil
    end

    it "should have the right associated event" do
      @event_p.event_id.should == @event.id
      @event_p.event.should == @event
    end
  end

  describe "Reject" do
    it "should be deny nil pupil_id" do
      expect do
        PupilsEvent.create( :pupil_id => nil, :event_id => @event.id ).should_not be_valid
      end.should_not change( PupilsEvent, :count )
    end

    it "should be deny nil event_id" do
      expect do
        PupilsEvent.create( :pupil_id => @pupil.id, :event_id => nil ).should_not be_valid
      end.should_not change( PupilsEvent, :count )
    end
  end
end
