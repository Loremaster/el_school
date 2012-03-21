# encoding: UTF-8
# Created by 'bundle exec annotate --position before'
# == Schema Information
#
# Table name: teacher_educations
#
#  id                           :integer         not null, primary key
#  user_id                      :integer
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
    @user = Factory(:user)
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
  
  describe "User-TeacherEducation creation" do
    it "should create teacher education via user" do
      expect do
        @user.create_teacher_education( @attr_teacher_edu )
      end.should change( TeacherEducation, :count ).by( 1 )
    end

    it "should not create invalid teacher education via user" do
      expect do
        @user.create_teacher_education( @attr_invalid_teacher_edu )
      end.should_not change( TeacherEducation, :count )
    end  
  end
  
  describe "User-TeacherEducation association" do
    before(:each) do
      @teacher_edu = @user.create_teacher( @attr_teacher_edu )
    end
    
    it "should have a user attribute" do
      @teacher_edu.should respond_to(:user)
    end
    
    it "should have the right associated user" do
      @teacher_edu.user_id.should == @user.id
      @teacher_edu.user.should == @user
    end
  end
  
  describe "Validations of teacher education" do
    it "should require a user id" do
      TeacherEducation.new( @attr_teacher_edu ).should_not be_valid
    end
    
    it "should reject blank teacher university" do
      @user.build_teacher_education( @attr_teacher_edu.merge(:teacher_education_university => "  " ) ).should_not be_valid
    end 
    
    it "should reject too long teacher university" do
      text = "a" * 101 
      @user.build_teacher_education( @attr_teacher_edu.merge(:teacher_education_university => text ) ).should_not be_valid
    end
    
    it "should reject blank teacher graduation" do
      @user.build_teacher_education( @attr_teacher_edu.merge(:teacher_education_graduation => "  " ) ).should_not be_valid
    end 
    
    it "should reject too long teacher graduation" do
      text = "a" * 31 
      @user.build_teacher_education( @attr_teacher_edu.merge(:teacher_education_graduation => text ) ).should_not be_valid
    end
    
    it "should reject blank teacher speciality" do
      @user.build_teacher_education( @attr_teacher_edu.merge(:teacher_education_speciality => "  " ) ).should_not be_valid
    end
    
    it "should reject too long teacher speciality" do
      text = "a" * 31 
      @user.build_teacher_education( @attr_teacher_edu.merge(:teacher_education_graduation => text ) ).should_not be_valid
    end
    
    it "should reject empty date" do
      @user.build_teacher_education( @attr_teacher_edu.merge(:teacher_education_year => " " ) ).should_not be_valid
    end
  end
end
