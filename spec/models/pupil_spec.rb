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
    @user = Factory(:user)
    @school_class = Factory(:school_class)
    
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
  end
end
