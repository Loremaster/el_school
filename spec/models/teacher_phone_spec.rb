# encoding: UTF-8
# Created by 'bundle exec annotate --position before'
# == Schema Information
#
# Table name: teacher_phones
#
#  id                    :integer         not null, primary key
#  teacher_id            :integer
#  teacher_home_number   :string(255)
#  teacher_mobile_number :string(255)
#  created_at            :datetime        not null
#  updated_at            :datetime        not null
#

require 'spec_helper'

describe TeacherPhone do
  before(:each) do
    @teacher = FactoryGirl.create( :teacher )

    @attr_teacher_phones = {
      :teacher_mobile_number => "8903111111",
      :teacher_home_number => "7773322"
    }

    @attr_invalid_teacher_phones = {
      :teacher_mobile_number => " ",
      :teacher_home_number => " "
    }
  end

  describe "Teacher-TeacherPhone creation" do
    it "should create teacher phones via teacher" do
      expect do
        @teacher.create_teacher_phone( @attr_teacher_phones )
      end.should change( TeacherPhone, :count ).by( 1 )
    end

    it "should not create invalid teacher phones via teacher" do
      expect do
        @teacher.create_teacher_education( @attr_invalid_teacher_phones )
      end.should_not change( TeacherEducation, :count )
    end
  end

  describe "Teacher-TeacherPhone association" do
    before(:each) do
      @teacher_ph = @teacher.create_teacher_phone( @attr_teacher_phones )
    end

    it "should have a teacher attribute" do
      @teacher_ph.should respond_to(:teacher)
    end

    it "should have right associated teacher" do
      @teacher_ph.teacher_id.should == @teacher.id
      @teacher_ph.teacher.should == @teacher
    end
  end

  describe "Validations" do
    it "should not require a user id" do
      TeacherPhone.new( @attr_teacher_phones ).should be_valid
    end

    it "should reject blank teacher home phone number" do
      @teacher.build_teacher_phone( @attr_teacher_phones.merge(:teacher_home_number => "  " ) ).should_not be_valid
    end

    it "should reject too long teacher home phone number" do
      p = 'p' * 16
      @teacher.build_teacher_phone( @attr_teacher_phones.merge(:teacher_home_number => p) ).should_not be_valid
    end

    it "should reject blank teacher mobile phone number" do
      @teacher.build_teacher_phone( @attr_teacher_phones.merge(:teacher_mobile_number => "  " ) ).should_not be_valid
    end

    it "should reject too long teacher mobile phone number" do
      p = 'p' * 16
      @teacher.build_teacher_phone( @attr_teacher_phones.merge(:teacher_mobile_number => p ) ).should_not be_valid
    end

    it "should reject home number if it something else except digits" do
      p = "asdf"
      @teacher.build_teacher_phone( @attr_teacher_phones.merge(:teacher_home_number => p ) ).should_not be_valid
    end

    it "should reject mobile number if it something else except digits" do
      p = "asdf"
      @teacher.build_teacher_phone( @attr_teacher_phones.merge(:teacher_mobile_number => p ) ).should_not be_valid
    end
  end
end
