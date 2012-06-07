# encoding: UTF-8
# Created by 'bundle exec annotate --position before'
# == Schema Information
#
# Table name: pupils
#
#  id                            :integer         not null, primary key
#  user_id                       :integer
#  school_class_id               :integer
#  pupil_last_name               :string(255)
#  pupil_first_name              :string(255)
#  pupil_middle_name             :string(255)
#  pupil_birthday                :date
#  pupil_sex                     :string(255)
#  pupil_nationality             :string(255)
#  pupil_address_of_registration :string(255)
#  pupil_address_of_living       :string(255)
#  created_at                    :datetime        not null
#  updated_at                    :datetime        not null
#

require 'spec_helper'

describe Pupil do
  before(:each) do
    @user = FactoryGirl.create( :user )
    @school_class = FactoryGirl.create( :school_class )

    @attr_pupil = {
      :pupil_last_name => "Смирнов",
      :pupil_first_name => "Петр",
      :pupil_middle_name => "Петрович",
      :pupil_birthday => "#{Date.today - 10.years}",
      :pupil_sex => "m",
      :pupil_nationality => "Русский",
      :pupil_address_of_registration => "Москва, ул. Ленина, д. 1",
      :pupil_address_of_living => "Москва, ул. Ленина, д. 1",
      :school_class_id => @school_class.id
    }
  end

  describe "Creation" do
    it "should create pupil via user with valid attributes" do
      expect do
        @user.create_pupil( @attr_pupil ).should be_valid
      end.should change( Pupil, :count ).by( 1 )
    end

    it "should reject to create pupil via user with wrong attributes" do
      expect do
        @user.create_pupil( @attr_pupil.merge(:pupil_sex => '11') ).should_not be_valid
      end.should_not change( Pupil, :count ).by( 1 )
    end
  end

  describe "User-Pupil association" do
    before(:each) do
      @pupil = @user.create_pupil( @attr_pupil )
    end

    it "should have a user attribute" do
      @pupil.should respond_to( :user )
    end

    it "should have the right associated user" do
      @pupil.user_id.should == @user.id
      @pupil.user.should == @user
    end

    it "should have the right associated school class" do
      @pupil.school_class_id.should == @school_class.id
      @pupil.school_class.should == @school_class
    end

    it "should not require school class id" do                                            # Otherwise it's to comlicate to create pupil.
      @pupil.school_class_id = nil
      @pupil.should be_valid
    end
  end

  describe "Validations" do
    describe "Rejection" do
      it "should reject blank last name" do
        wrong_attr = @attr_pupil.merge( :pupil_last_name => "  " )
        @user.build_pupil( wrong_attr ).should_not be_valid
      end

      it "should reject too long last name" do
        wrong_attr = @attr_pupil.merge( :pupil_last_name => 'a' * 41 )
        @user.build_pupil( wrong_attr ).should_not be_valid
      end

      it "should reject blank first name" do
        wrong_attr = @attr_pupil.merge( :pupil_first_name => "  " )
        @user.build_pupil( wrong_attr ).should_not be_valid
      end

      it "should reject too long first name" do
        wrong_attr = @attr_pupil.merge( :pupil_first_name => 'a' * 41 )
        @user.build_pupil( wrong_attr ).should_not be_valid
      end

      it "should reject blank middle name" do
        wrong_attr = @attr_pupil.merge( :pupil_middle_name => "  " )
        @user.build_pupil( wrong_attr ).should_not be_valid
      end

      it "should reject too long middle name" do
        wrong_attr = @attr_pupil.merge( :pupil_middle_name => 'a' * 41 )
        @user.build_pupil( wrong_attr ).should_not be_valid
      end

      it "should reject birthdays of pupils if they younger then 5 years old" do
        dates = ( Date.today - 4.year )..( Date.today + 20.year)
        dates.each do |d|
          wrong_attr = @attr_pupil.merge( :pupil_birthday => d )
          @user.build_pupil( wrong_attr ).should_not be_valid
        end
      end

      it "should reject birthdays of pupils if they older then 19 years old" do
        dates = ( Date.today - 30.year )..( Date.today - 20.year)
        dates.each do |d|
          wrong_attr = @attr_pupil.merge( :pupil_birthday => d )
          @user.build_pupil( wrong_attr ).should_not be_valid
        end
      end

      it "should reject wrong sex chars" do
        sex = %w(M W K F)
        sex.each do |sex|
          wrong_pupil = @user.build_pupil( @attr_pupil.merge( :pupil_sex => sex ) )
          wrong_pupil.should_not be_valid
        end
      end

      it "should reject blank nationality" do
        wrong_attr = @attr_pupil.merge( :pupil_nationality => "  " )
        @user.build_pupil( wrong_attr ).should_not be_valid
      end

      it "should reject too long nationality" do
        wrong_attr = @attr_pupil.merge( :pupil_nationality => 'a' * 51 )
        @user.build_pupil( wrong_attr ).should_not be_valid
      end

      it "should reject blank address of registration" do
        wrong_attr = @attr_pupil.merge( :pupil_address_of_registration => "  " )
        @user.build_pupil( wrong_attr ).should_not be_valid
      end

      it "should reject too long address of registration" do
        wrong_attr = @attr_pupil.merge( :pupil_address_of_registration => 'a' * 251 )
        @user.build_pupil( wrong_attr ).should_not be_valid
      end

      it "should reject blank address of living" do
        wrong_attr = @attr_pupil.merge( :pupil_address_of_living => "  " )
        @user.build_pupil( wrong_attr ).should_not be_valid
      end

      it "should reject too long address of living" do
        wrong_attr = @attr_pupil.merge( :pupil_address_of_living => 'a' * 251 )
        @user.build_pupil( wrong_attr ).should_not be_valid
      end

      it "should reject last name with digits" do
        wrong_attr = @attr_pupil.merge( :pupil_last_name => 'asd2' )
        @user.build_pupil( wrong_attr ).should_not be_valid
      end

      it "should reject last name with space" do
        wrong_attr = @attr_pupil.merge( :pupil_last_name => 'asd ' )
        @user.build_pupil( wrong_attr ).should_not be_valid
      end

      it "should reject first name with digits" do
        wrong_attr = @attr_pupil.merge( :pupil_first_name => 'asd2' )
        @user.build_pupil( wrong_attr ).should_not be_valid
      end

      it "should reject first name with space" do
        wrong_attr = @attr_pupil.merge( :pupil_first_name => 'asd ' )
        @user.build_pupil( wrong_attr ).should_not be_valid
      end

      it "should reject middle name with digits" do
        wrong_attr = @attr_pupil.merge( :pupil_middle_name => 'asd2' )
        @user.build_pupil( wrong_attr ).should_not be_valid
      end

      it "should reject middle name with space" do
        wrong_attr = @attr_pupil.merge( :pupil_middle_name => 'asd ' )
        @user.build_pupil( wrong_attr ).should_not be_valid
      end
    end

    describe "Acceptance" do
      it "should accept last name if length is correct" do
        (1..40).each do |i|
          correct_attr = @attr_pupil.merge( :pupil_last_name => 'a' * i  )
          @user.build_pupil( correct_attr ).should be_valid
        end
      end

      it "should accept first name if length is correct" do
        (1..40).each do |i|
          correct_attr = @attr_pupil.merge( :pupil_first_name => 'a' * i  )
          @user.build_pupil( correct_attr ).should be_valid
        end
      end

      it "should accept middle name if length is correct" do
        (1..40).each do |i|
          correct_attr = @attr_pupil.merge( :pupil_middle_name => 'a' * i  )
          @user.build_pupil( correct_attr ).should be_valid
        end
      end

      it "should accept birthdays of pupils if its correct" do
        dates = ( Date.today - 19.year )..( Date.today - 5.year )
        dates.each do |d|
          correct_attr = @attr_pupil.merge( :pupil_birthday => d )
          @user.build_pupil( correct_attr ).should be_valid
        end
      end

      it "should accept correct sex chars" do
        sex = %w(m w)
        sex.each do |sex|
          correct_attr = @user.build_pupil( @attr_pupil.merge( :pupil_sex => sex ) )
          correct_attr.should be_valid
        end
      end

      it "should accept nationality if length is correct" do
        (1..50).each do |i|
          correct_attr = @attr_pupil.merge( :pupil_nationality => 'a' * i  )
          @user.build_pupil( correct_attr ).should be_valid
        end
      end

      it "should accept address of registration if length is correct" do
        (1..250).each do |i|
          correct_attr = @attr_pupil.merge( :pupil_address_of_registration => 'a' * i  )
          @user.build_pupil( correct_attr ).should be_valid
        end
      end

      it "should accept address of living if length is correct" do
        (1..250).each do |i|
          correct_attr = @attr_pupil.merge( :pupil_address_of_living => 'a' * i  )
          @user.build_pupil( correct_attr ).should be_valid
        end
      end
    end
  end
end
