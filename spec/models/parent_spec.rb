# Created by 'bundle exec annotate --position before'
# == Schema Information
#
# Table name: parents
#
#  id                 :integer         not null, primary key
#  user_id            :integer
#  parent_last_name   :string(255)
#  parent_first_name  :string(255)
#  parent_middle_name :string(255)
#  parent_birthday    :date
#  parent_sex         :string(255)
#  created_at         :datetime        not null
#  updated_at         :datetime        not null
#

require 'spec_helper'

describe Parent do
  before(:each) do
    @user = FactoryGirl.create( :user )
    @attr_parent = {
      :parent_last_name   => 'Ivanon',
      :parent_first_name  => 'Kirril',
      :parent_middle_name => 'Igorevich',
      :parent_birthday    => "#{Date.today - 20.years}",
      :parent_sex         => 'm'    
    }
  end
  
  describe "Creation" do
    it "should create parent via user with valid attributes" do
      expect do
        @user.create_parent( @attr_parent ).should be_valid  
      end.should change( Parent, :count ).by( 1 )
    end
    
    it "should reject to create parent via user with wrong attributes" do
      expect do
        @user.create_parent( @attr_parent.merge(:parent_sex => '11') ).should_not be_valid  
      end.should_not change( Parent, :count )
    end
  end
  
  describe "User-Parent association" do
    before(:each) do
      @parent = @user.create_parent( @attr_parent )
    end
    
    it "should have a user attribute" do
      @parent.should respond_to( :user )
    end
    
    it "should have the right associated user" do
      @parent.user_id.should == @user.id
      @parent.user.should == @user
    end        
  end
  
  describe "Validations" do
    describe "Rejection" do
      it "should reject blank last name" do
        wrong_attr = @attr_parent.merge( :parent_last_name => "  " )
        @user.build_parent( wrong_attr ).should_not be_valid
      end
      
      it "should reject too long last name" do
        wrong_attr = @attr_parent.merge( :parent_last_name => 'a' * 41 )
        @user.build_parent( wrong_attr ).should_not be_valid
      end
      
      it "should reject blank first name" do
        wrong_attr = @attr_parent.merge( :parent_first_name => "  " )
        @user.build_parent( wrong_attr ).should_not be_valid
      end
      
      it "should reject too long first name" do
        wrong_attr = @attr_parent.merge( :parent_first_name => 'a' * 41 )
        @user.build_parent( wrong_attr ).should_not be_valid
      end
      
      it "should reject blank middle name" do
        wrong_attr = @attr_parent.merge( :parent_middle_name => "  " )
        @user.build_parent( wrong_attr ).should_not be_valid
      end
      
      it "should reject too long middle name" do
        wrong_attr = @attr_parent.merge( :parent_middle_name => 'a' * 41 )
        @user.build_parent( wrong_attr ).should_not be_valid
      end
            
      it "should reject birthdays of parents if they younger then 18 years old" do
        dates = ( Date.today )..( Date.today + 17.years )
        dates.each do |d| 
          wrong_attr = @attr_parent.merge( :parent_birthday => d )
          @user.build_parent( wrong_attr ).should_not be_valid
        end
      end
      
      it "should reject birthdays of parents if they older then 100 years old" do
        dates = ( Date.today - 110.years )..( Date.today - 101.years )
        dates.each do |d| 
          wrong_attr = @attr_parent.merge( :parent_birthday => d )
          @user.build_parent( wrong_attr ).should_not be_valid
        end
      end
      
      it "should reject wrong sex chars" do
        sex = %w(M W K F)
        sex.each do |sex|  
          wrong_parent = @user.build_parent( @attr_parent.merge( :parent_sex => sex ) )
          wrong_parent.should_not be_valid     
        end
      end
    end
  
    describe "Acceptance" do
      it "should accept last name if length is correct" do
        (1..40).each do |i|
          correct_attr = @attr_parent.merge( :parent_last_name => 'a' * i  ) 
          @user.build_parent( correct_attr ).should be_valid
        end
      end
      
      it "should accept first name if length is correct" do
        (1..40).each do |i|
          correct_attr = @attr_parent.merge( :parent_first_name => 'a' * i  ) 
          @user.build_parent( correct_attr ).should be_valid
        end
      end
      
      it "should accept middle name if length is correct" do
        (1..40).each do |i|
          correct_attr = @attr_parent.merge( :parent_middle_name => 'a' * i  ) 
          @user.build_parent( correct_attr ).should be_valid
        end
      end
      
      it "should accept correct birthdays of parents" do
        dates = ( Date.today - 100.years )..( Date.today - 18.years )
        dates.each do |d| 
          correct_attr = @attr_parent.merge( :parent_birthday => d )
          @user.build_parent( correct_attr ).should be_valid
        end
      end
      
      it "should accept correct sex chars" do
        sex = %w(m w)
        sex.each do |sex|  
          correct_attr = @user.build_parent( @attr_parent.merge( :parent_sex => sex ) )
          correct_attr.should be_valid     
        end
      end
    end
  end
end
