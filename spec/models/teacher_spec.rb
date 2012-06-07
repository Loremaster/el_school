# encoding: UTF-8
# Created by 'bundle exec annotate --position before'
# == Schema Information
#
# Table name: teachers
#
#  id                  :integer         not null, primary key
#  user_id             :integer
#  teacher_last_name   :string(255)
#  teacher_first_name  :string(255)
#  teacher_middle_name :string(255)
#  teacher_birthday    :date
#  teacher_sex         :string(255)
#  teacher_category    :string(255)
#  created_at          :datetime        not null
#  updated_at          :datetime        not null
#

require 'spec_helper'

describe Teacher do
  before(:each) do
    @user = FactoryGirl.create( :user )
    @attr_teacher = {
        :teacher_last_name   => "Каров",
        :teacher_first_name  => "Петр",
        :teacher_middle_name => "Иванович",
        :teacher_birthday    => "01.12.1980",                                             #dd.mm.yyyy
        :teacher_sex         => "m",
        :teacher_category    => "1я Категория"
    }

    @attr_invalid_teacher = {
        :teacher_last_name   => "Каров",
        :teacher_first_name  => "Петр",
        :teacher_middle_name => "Иванович",
        :teacher_birthday    => "",                                                       #dd.mm.yyyy
        :teacher_sex         => "",
        :teacher_category    => ""
    }
  end

  describe "Teacher creation" do
    it "should create valid teacher via user" do
      expect do
        @user.create_teacher( @attr_teacher )
      end.should change( Teacher, :count ).by( 1 )
    end

    it "should not create invalid teacher via user" do
      expect do
        @user.create_teacher( @attr_invalid_teacher )
      end.should_not change( Teacher, :count )
    end
  end

  describe "User-Teacher association" do
    before(:each) do
      @teacher = @user.create_teacher( @attr_teacher )
    end

    it "should have a user attribute" do
      @teacher.should respond_to(:user)
    end

    it "should have the right associated user" do
      @teacher.user_id.should == @user.id
      @teacher.user.should == @user
    end
  end

  describe "Validations of teacher" do
    it "should not require a user id" do
      Teacher.new( @attr_teacher ).should be_valid
    end

    it "should reject blank teacher last name" do
      @user.build_teacher( @attr_teacher.merge(:teacher_last_name => "  " ) ).should_not be_valid
    end

    it "should reject too long teacher last name" do
      text = "a" * 41
      @user.build_teacher( @attr_teacher.merge(:teacher_last_name => text ) ).should_not be_valid
    end

    it "should reject blank teacher first name" do
      @user.build_teacher( @attr_teacher.merge(:teacher_first_name => "  " ) ).should_not be_valid
    end

    it "should reject too long teacher first name" do
      text = "a" * 41
      @user.build_teacher( @attr_teacher.merge(:teacher_first_name => text ) ).should_not be_valid
    end

    it "should reject blank teacher middle name" do
      @user.build_teacher( @attr_teacher.merge(:teacher_middle_name => "  " ) ).should_not be_valid
    end

    it "should reject too long teacher middle name" do
      text = "a" * 41
      @user.build_teacher( @attr_teacher.merge(:teacher_middle_name => text ) ).should_not be_valid
    end

    it "should accept right sex chars" do
      teacher_sex = %w(m w)
      teacher_sex.each do |sex|
        correct_teacher =  @user.build_teacher( @attr_teacher.merge(:teacher_sex => sex ) )
        correct_teacher.should be_valid
      end
    end

    it "should reject wrong sex chars" do
      teacher_sex = %w(M W K F)
      teacher_sex.each do |sex|
        wrong_teacher =  @user.build_teacher( @attr_teacher.merge(:teacher_sex => sex ) )
        wrong_teacher.should_not be_valid
      end
    end

    it "should accept blank teacher category" do
      @user.build_teacher( @attr_teacher.merge(:teacher_category => "  " ) ).should be_valid
    end

    it "should reject too long teacher category" do
      text = "a" * 21
      @user.build_teacher( @attr_teacher.merge(:teacher_category => text ) ).should_not be_valid
    end

    it "should accept blank teacher birthday" do
      @user.build_teacher( @attr_teacher.merge(:teacher_birthday => "  " ) ).should_not be_valid
    end

    it "should reject teacher last name with digits" do
      @user.build_teacher( @attr_teacher.merge(:teacher_last_name => "asd2" ) ).should_not be_valid
    end

    it "should reject teacher last name with space" do
      @user.build_teacher( @attr_teacher.merge(:teacher_last_name => "asd " ) ).should_not be_valid
    end

    it "should reject teacher first name with digits" do
      @user.build_teacher( @attr_teacher.merge(:teacher_first_name => "asd2" ) ).should_not be_valid
    end

    it "should reject teacher first name with space" do
      @user.build_teacher( @attr_teacher.merge(:teacher_first_name => "asd " ) ).should_not be_valid
    end

    it "should reject teacher middle name with digits" do
      @user.build_teacher( @attr_teacher.merge(:teacher_middle_name => "asd2" ) ).should_not be_valid
    end

    it "should reject teacher middle name with space" do
      @user.build_teacher( @attr_teacher.merge(:teacher_middle_name => "asd " ) ).should_not be_valid
    end
  end
end
