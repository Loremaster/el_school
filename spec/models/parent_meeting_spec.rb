# Created by 'bundle exec annotate --position before'
# == Schema Information
#
# Table name: parent_meetings
#
#  id         :integer         not null, primary key
#  parent_id  :integer
#  meeting_id :integer
#  created_at :datetime        not null
#  updated_at :datetime        not null
#

require 'spec_helper'

describe ParentMeeting do
  before(:each) do
    @parent = FactoryGirl.create( :parent )
    @meeting = FactoryGirl.create( :meeting )
  end
  
  describe "ParentMeeting creation" do
    it "should be success" do
      expect do
        ParentMeeting.create(:parent_id => @parent.id, :meeting_id => @meeting.id  )
      end.should change( ParentMeeting, :count ).by( 1 ) 
    end
  end
  
  describe "ParentMeeting association" do
    before(:each) do
      @parent_meeting = ParentMeeting.create( :parent_id => @parent.id, 
                                              :meeting_id => @meeting.id )
    end
    
    it "should have a meeting attribute" do
      @parent_meeting.should respond_to( :meeting )
    end
    
    it "should have a parent attribute" do
      @parent_meeting.should respond_to( :parent )
    end
    
    it "should have the right associated meeting" do
      @parent_meeting.meeting_id.should == @meeting.id  
      @parent_meeting.meeting.should == @meeting        
    end
    
    it "should have the right associated parent" do
      @parent_meeting.parent_id.should == @parent.id  
      @parent_meeting.parent.should == @parent        
    end
  end
end
