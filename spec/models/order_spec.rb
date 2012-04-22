# encoding: UTF-8
# Created by 'bundle exec annotate --position before'
# == Schema Information
#
# Table name: orders
#
#  id              :integer         not null, primary key
#  pupil_id        :integer
#  school_class_id :integer
#  number_of_order :string(255)
#  date_of_order   :date
#  text_of_order   :text
#  created_at      :datetime        not null
#  updated_at      :datetime        not null
#

require 'spec_helper'

describe Order do
  before(:each) do
    @pupil = FactoryGirl.create(:pupil)
    @school_class = FactoryGirl.create(:school_class)
    
    @attr_order = {
      :school_class_id => @school_class.id,
      :number_of_order => "1532",
      :date_of_order   => "#{Date.today}",
      :text_of_order   => "This pupil has been transfered."
    }
  end
  
  describe "Creation" do
    it "should create order via pupil with valid attributes" do
      expect do
        @pupil.orders.create( @attr_order ).should be_valid 
      end.should change( Order, :count ).by( 1 )
    end
    
    it "should reject to create order via pupil with wrong attributes" do
      expect do
        order = @pupil.orders.create( @attr_order.merge( :number_of_order => ' ' ) )
        order.should_not be_valid
      end.should_not change( Order, :count )
    end
  end
  
  describe "Order associations" do
    before(:each) do
      @order = @pupil.orders.create( @attr_order )
    end
    
    it "should have school class attribute" do
      @order.should respond_to( :school_class )
    end
    
    it "should have pupil attribute" do
      @order.should respond_to( :pupil )
    end
    
    it "should have right associated pupil" do
      @order.pupil_id.should == @pupil.id
      @order.pupil.should == @pupil
    end
    
    it "should have right associated school class" do
      @order.school_class_id.should == @school_class.id
      @order.school_class.should == @school_class
    end
  end
  
  describe "Validations" do
    describe "Rejection" do 
      it "should reject blank number of order" do
        wrong_attr = @attr_order.merge( :number_of_order => "  " )
        @pupil.orders.build( wrong_attr ).should_not be_valid
      end
    
      it "should reject too long number of order" do
        wrong_attr = @attr_order.merge( :number_of_order => 'a' * 16 )
        @pupil.orders.build( wrong_attr ).should_not be_valid
      end
    
      it "should reject date of order of pupils if date < 1 from now" do
        dates = ( Date.today - 5.years )..( Date.today - 2.years )
        dates.each do |d| 
          wrong_attr = @attr_order.merge( :date_of_order => d )
          @pupil.orders.build( wrong_attr ).should_not be_valid
        end
      end 
    
      it "should reject date of order of pupils if date > 1 from now" do
        dates = ( Date.today + 2.years )..( Date.today + 5.years )
        dates.each do |d| 
          wrong_attr = @attr_order.merge( :date_of_order => d )
          @pupil.orders.build( wrong_attr ).should_not be_valid
        end
      end
    
      it "should reject blank text of order" do
        wrong_attr = @attr_order.merge( :text_of_order => "  " )
        @pupil.orders.build( wrong_attr ).should_not be_valid
      end
    
      it "should reject too long text of order" do
        wrong_attr = @attr_order.merge( :text_of_order => 'a' * 501 )
        @pupil.orders.build( wrong_attr ).should_not be_valid
      end
    end                       
  
    describe "Acceptance" do
      it "should accept number of order if length is correct" do
        (1..15).each do |i|
          correct_attr = @attr_order.merge( :number_of_order => 'a' * i  ) 
          @pupil.orders.build( correct_attr ).should be_valid
        end
      end
      
      it "should accept date of order of pupils if 1 <= date <= 1 years from now" do
        dates = ( Date.today - 1.year )..( Date.today + 1.year )
        dates.each do |d| 
          correct_attr = @attr_order.merge( :date_of_order => d )
          @pupil.orders.build( correct_attr ).should be_valid
        end
      end
      
      it "should accept text of order if length is correct" do
        (1..500).each do |i|
          correct_attr = @attr_order.merge( :text_of_order => 'a' * i  ) 
          @pupil.orders.build( correct_attr ).should be_valid
        end
      end
    end
  end                       
end
