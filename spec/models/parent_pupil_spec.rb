# == Schema Information
#
# Table name: parent_pupils
#
#  id         :integer         not null, primary key
#  pupil_id   :integer
#  parent_id  :integer
#  created_at :datetime        not null
#  updated_at :datetime        not null
#

require 'spec_helper'

describe ParentPupil do
  before(:each) do
    @parent = FactoryGirl.create( :parent )
    @pupil = FactoryGirl.create( :pupil )
  end
  
  describe "ParentPupil creation" do
    it "should be success" do
      expect do
        ParentPupil.create( :pupil_id => @pupil.id, :parent_id => @parent.id )
      end.should change( ParentPupil, :count ).by( 1 ) 
    end 
  end
  
  describe "ParentPupil association" do
    before(:each) do
      @parent_pupil = ParentPupil.create( :pupil_id => @pupil.id, :parent_id => @parent.id )
    end
    
    it "should have a pupil attribute" do
      @parent_pupil.should respond_to( :pupil )
    end
    
    it "should have a parent attribute" do
      @parent_pupil.should respond_to( :parent )
    end
    
    it "should have the right associated pupil" do
      @parent_pupil.pupil_id.should == @pupil.id  
      @parent_pupil.pupil.should == @pupil        
    end
    
    it "should have the right associated parent" do
      @parent_pupil.parent_id.should == @parent.id  
      @parent_pupil.parent.should == @parent        
    end
  end
end
