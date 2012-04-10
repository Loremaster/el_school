# Created by 'bundle exec annotate --position before'
# == Schema Information
#
# Table name: school_classes
#
#  id                     :integer         not null, primary key
#  teacher_leader_id      :integer
#  class_code             :string(255)
#  date_of_class_creation :date
#  created_at             :datetime        not null
#  updated_at             :datetime        not null
#

require 'spec_helper'

describe SchoolClass do
  before(:each) do
    @user = Factory( :user )
    @teacher = Factory( :teacher, 
                        :user => Factory( :user, :user_login => Factory.next( :user_login )))
    @teacher_leader = @user.create_teacher_leader({ :user_id => @user.id, 
                                                    :teacher_id => @teacher.id })
    
    @attr_school_class = {
      :class_code => "11k",
      :date_of_class_creation => Date.today
    }
  end
  
  describe "TeacherLeader-SchoolClass creation" do
    it "should create school's class" do
      expect do
        @sch_class = @teacher_leader.create_school_class( @attr_school_class )
      end.should change( SchoolClass, :count ).by( 1 )
    end
    
    it "should reject to create school's class wit wrong attributes" do
      expect do
        wrong_attr = @attr_school_class.merge( :date_of_class_creation => Date.today - 2.years ) 
        @sch_class = @teacher_leader.create_school_class( wrong_attr ) 
      end.should_not change( SchoolClass, :count )
    end
  end
  
  describe "TeacherLeader-SchoolClass association" do
    before(:each) do
      @sch_class = @teacher_leader.create_school_class( @attr_school_class )
    end
    
    it "should have a teacher leader attribute" do
      @sch_class.should respond_to( :teacher_leader )
    end
    
    it "should have the right associated teacher leader" do
      @sch_class.teacher_leader_id.should == @teacher_leader.id
      @sch_class.teacher_leader.should == @teacher_leader
    end
  end
  
  describe "Validations" do
    describe "Rejection" do
      it "should not require a teacher leader id" do
        SchoolClass.new( @attr_school_class ).should be_valid
      end  

      it "should reject blank class code" do
        wrong_attr = @attr_school_class.merge( :class_code => "  " )
        @teacher_leader.build_school_class( wrong_attr ).should_not be_valid
      end

      it "should reject too long class code" do
        wrong_attr = @attr_school_class.merge( :class_code => 'a' * 4 )
        @teacher_leader.build_school_class( wrong_attr ).should_not be_valid
      end

      it "should reject too old dates if their date > 365(6) days from now" do
        dates = ( Date.today - 10.year )..( Date.today - 2.year )
        dates.each do |d| 
          wrong_attr = @attr_school_class.merge( :date_of_class_creation => d )
          @teacher_leader.build_school_class( wrong_attr ).should_not be_valid
        end
      end 
      
      it "should reject future dates if their date > 365(6) days from now" do
        dates = ( Date.today + 10.year )..( Date.today + 2.year )
        dates.each do |d| 
          wrong_attr = @attr_school_class.merge( :date_of_class_creation => d )
          @teacher_leader.build_school_class( wrong_attr ).should_not be_valid
        end
      end 
    end
    
    describe "Acception" do
      it "should accept class code with correct length" do
        codes = %w(a aa aaa)
        codes.each do |code|
          correct_attr = @attr_school_class.merge( :class_code => code )
          @teacher_leader.build_school_class( correct_attr ).should be_valid
        end  
      end
      
      it "should accept correct date (current dat +/- 1)" do
        dates = ( Date.today - 1.year )..( Date.today + 1.year )
        dates.each do |d| 
          correct_attr = @attr_school_class.merge( :date_of_class_creation => d )
          @teacher_leader.build_school_class( correct_attr ).should be_valid
        end
      end
    end    
  end
end
