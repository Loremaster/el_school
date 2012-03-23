# encoding: UTF-8
# Created by 'bundle exec annotate --position before'
# == Schema Information
#
# Table name: teacher_educations
#
#  id                           :integer         not null, primary key
#  teacher_id                   :integer
#  teacher_education_university :string(255)
#  teacher_education_year       :date
#  teacher_education_graduation :string(255)
#  teacher_education_speciality :string(255)
#  created_at                   :datetime        not null
#  updated_at                   :datetime        not null
#

require 'spec_helper'

describe TeacherEducation do
  before(:each) do
    @teacher = Factory(:teacher)
    
    @attr_teacher_edu = {
      :teacher_education_university => "МГУ",
      :teacher_education_year => "01.01.1970",
      :teacher_education_graduation => "Специалист",
      :teacher_education_speciality => "Механика и математика"
    }
    @attr_invalid_teacher_edu = {
      :teacher_education_university => "МГУ",
      :teacher_education_year => "",
      :teacher_education_graduation => "Специалист",
      :teacher_education_speciality => "Механика и математика"
    }
  end
  
  describe "Teacher-TeacherEducation creation" do
    it "should create teacher education via user" do
      expect do
        @teacher.create_teacher_education( @attr_teacher_edu )
      end.should change( TeacherEducation, :count ).by( 1 )
    end
  
    it "should not create invalid teacher education via user" do
      expect do
        @teacher.create_teacher_education( @attr_invalid_teacher_edu )
      end.should_not change( TeacherEducation, :count )
    end  
  end
  
  describe "User-TeacherEducation association" do
    before(:each) do
      @teacher_edu = @teacher.create_teacher_education( @attr_teacher_edu )
    end
    
    it "should have a user attribute" do
      @teacher_edu.should respond_to(:teacher)
    end
    
    it "should have the right associated user" do
      @teacher_edu.teacher_id.should == @teacher.id
      @teacher_edu.teacher.should == @teacher
    end
  end
  
  describe "Validations of teacher education" do
    it "should not require a user id" do
      TeacherEducation.new( @attr_teacher_edu ).should be_valid
    end
    
    it "should reject blank teacher university" do
      @teacher.build_teacher_education( @attr_teacher_edu.merge(:teacher_education_university => "  " ) ).should_not be_valid
    end 
    
    it "should reject too long teacher university" do
      text = "a" * 101 
      @teacher.build_teacher_education( @attr_teacher_edu.merge(:teacher_education_university => text ) ).should_not be_valid
    end
    
    it "should reject blank teacher graduation" do
      @teacher.build_teacher_education( @attr_teacher_edu.merge(:teacher_education_graduation => "  " ) ).should_not be_valid
    end 
    
    it "should reject too long teacher graduation" do
      text = "a" * 31 
      @teacher.build_teacher_education( @attr_teacher_edu.merge(:teacher_education_graduation => text ) ).should_not be_valid
    end
    
    it "should reject blank teacher speciality" do
      @teacher.build_teacher_education( @attr_teacher_edu.merge(:teacher_education_speciality => "  " ) ).should_not be_valid
    end
    
    it "should reject too long teacher speciality" do
      text = "a" * 31 
      @teacher.build_teacher_education( @attr_teacher_edu.merge(:teacher_education_graduation => text ) ).should_not be_valid
    end
    
    it "should reject empty date" do
      @teacher.build_teacher_education( @attr_teacher_edu.merge(:teacher_education_year => " " ) ).should_not be_valid
    end
    end
end
