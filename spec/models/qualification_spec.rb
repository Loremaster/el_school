# == Schema Information
#
# Table name: qualifications
#
#  id         :integer         not null, primary key
#  subject_id :integer
#  teacher_id :integer
#  created_at :datetime        not null
#  updated_at :datetime        not null
#

require 'spec_helper'

describe Qualification do
  before(:each) do
    @subject = FactoryGirl.create( :subject )
    @teacher = FactoryGirl.create( :teacher )
  end
  
  describe "Qualification creation" do
    it "should be success" do
      expect do
        Qualification.create( :subject_id => @subject.id, :teacher_id => @teacher.id )
      end.should change( Qualification, :count ).by( 1 ) 
    end 
  end
  
  describe "Qualification association" do
    before(:each) do
      @qualification = Qualification.create( :subject_id => @subject.id, 
                                             :teacher_id => @teacher.id )
    end
    
    it "should have a teacher attribute" do
      @qualification.should respond_to(:teacher)
    end
    
    it "should have a subject attribute" do
      @qualification.should respond_to(:subject)
    end
    
    it "should have the right associated teacher" do
      @qualification.teacher_id.should == @teacher.id  
      @qualification.teacher.should == @teacher        
    end
    
    it "should have the right associated subject" do
      @qualification.subject_id.should == @subject.id  
      @qualification.subject.should == @subject        
    end                                    
  end
end
