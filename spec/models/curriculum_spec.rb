# Created by 'bundle exec annotate --position before'
# == Schema Information
#
# Table name: curriculums
#
#  id               :integer         not null, primary key
#  school_class_id  :integer
#  qualification_id :integer
#  created_at       :datetime        not null
#  updated_at       :datetime        not null
#

require 'spec_helper'

describe Curriculum do
  before(:each) do
    @subject = FactoryGirl.create( :subject )
    @teacher = FactoryGirl.create( :teacher )
    @qualification = Qualification.create( :subject_id => @subject.id, 
                                           :teacher_id => @teacher.id )
    @class = FactoryGirl.create( :school_class )                                       
  end
  
  describe "Curriculum creation" do
    it "should be success" do
      expect do
        Curriculum.create( :school_class_id => @class.id, 
                           :qualification_id => @qualification.id )
      end.should change( Curriculum, :count ).by( 1 ) 
    end 
  end
  
  describe "Curriculum association" do
    before(:each) do
      @curriculum = Curriculum.create( :school_class_id => @class.id, 
                                       :qualification_id => @qualification.id )
    end
    
    it "should have a teacher attribute" do
      @curriculum.should respond_to(:school_class)
    end
    
    it "should have a teacher attribute" do
      @curriculum.should respond_to(:qualification)
    end
    
    it "should have the right associated school class" do
      @curriculum.school_class_id.should == @class.id  
      @curriculum.school_class.should == @class        
    end
    
    it "should have the right associated qualification" do
      @curriculum.qualification_id.should == @qualification.id  
      @curriculum.qualification.should == @qualification        
    end
  end
end
