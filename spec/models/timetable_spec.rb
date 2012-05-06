# encoding: UTF-8
# Created by 'bundle exec annotate --position before'
# == Schema Information
#
# Table name: timetables
#
#  id                  :integer         not null, primary key
#  curriculum_id       :integer
#  tt_day_of_week      :string(255)
#  tt_number_of_lesson :integer
#  tt_room             :string(255)
#  tt_type             :string(255)
#  created_at          :datetime        not null
#  updated_at          :datetime        not null
#

require 'spec_helper'

describe Timetable do
  before(:each) do
    @curriculum = FactoryGirl.create( :curriculum )
    
    @attr_timetable = {
      :curriculum_id => @curriculum.id,
      :tt_day_of_week => "Mon",
      :tt_number_of_lesson => 1,
      :tt_room => '123',
      :tt_type => 'Primary lesson'
    }
    
    @attr_invalid_timetable = {
      :curriculum_id => @curriculum.id,
      :tt_day_of_week => "",
      :tt_number_of_lesson => 0,
      :tt_room => '12',
      :tt_type => ''
    }
  end
  
  describe "Timetable creation" do
    it "should create valid timetable via curriculum" do
      expect do
        Timetable.create( @attr_timetable ).should be_valid
      end.should change( Timetable, :count ).by( 1 ) 
    end
    
    it "should reject to create invalid timetable with invalid attribittes via curriculum" do
      expect do
        Timetable.create( @attr_invalid_timetable ).should_not be_valid
      end.should_not change( Timetable, :count ).by( 1 )
    end
  end
  
  describe "Validations" do
    describe "Rejection" do
      it "should reject blank or incorrect day of the week" do
        incorrect_days = ["", " ", "a", "aa", "aaa"]
        incorrect_days.each do |d| 
          wrong_attr = @attr_timetable.merge( :tt_day_of_week => d )
          Timetable.new( wrong_attr ).should_not be_valid 
        end
      end
      
      it "should reject incorrect number of lesson ( < 1 )" do
        incorrect_num_of_lesson = -5..0
        incorrect_num_of_lesson.each do |n|
          wrong_attr = @attr_timetable.merge( :tt_number_of_lesson => n )
          Timetable.new( wrong_attr ).should_not be_valid 
        end    
      end
      
      it "should reject incorrect number of lesson ( > 9 )" do
        incorrect_num_of_lesson = 10..15
        incorrect_num_of_lesson.each do |n|
          wrong_attr = @attr_timetable.merge( :tt_number_of_lesson => n )
          Timetable.new( wrong_attr ).should_not be_valid 
        end    
      end
      
      it "should reject too long room value" do
        wrong_attr = @attr_timetable.merge( :tt_room => 'a' * 4 )
        Timetable.new( wrong_attr ).should_not be_valid
      end
      
      it "should reject incorrect type of lesson" do
        incorrect_types = ["a", "aa", "aaa"]
        incorrect_types.each do |t| 
          wrong_attr = @attr_timetable.merge( :tt_type => t )
          Timetable.new( wrong_attr ).should_not be_valid 
        end
      end
    end
  
    describe "Acceptance" do
      it "should accept nil curriculum id" do
        correct_attr = @attr_timetable.merge( :curriculum_id => nil )
        Timetable.new( correct_attr ).should be_valid
      end
      
      it "should accept correct days of the week" do
        days = %w(Mon Tue Wed Thu Fri) 
        days.each do |d|
          correct_attr = @attr_timetable.merge( :tt_day_of_week => d )
          Timetable.new( correct_attr ).should be_valid 
        end 
      end
      
      it "should accept correct number lessons" do
        (1..9).each do |num|  
          correct_attr = @attr_timetable.merge( :tt_number_of_lesson => num )
          Timetable.new( correct_attr ).should be_valid
        end  
      end
      
      it "should accept nil room number" do
        correct_attr = @attr_timetable.merge( :tt_room => nil )
        Timetable.new( correct_attr ).should be_valid
      end
      
      it "should accept empty room number" do
        correct_attr = @attr_timetable.merge( :tt_room => '' )
        Timetable.new( correct_attr ).should be_valid
      end
      
      it "should accept correct room number" do
        rooms = [nil, "","1", "11", "111"]
        rooms.each do |r|
          correct_attr = @attr_timetable.merge( :tt_room => r )
          Timetable.new( correct_attr ).should be_valid 
        end
      end
      
      it "should accept correct type of lesson" do
        types = ["Primary lesson", "Extra", "", nil]
        types.each do |t|
          correct_attr = @attr_timetable.merge( :tt_type => t )
          Timetable.new( correct_attr ).should be_valid 
        end
      end
      
      it "should accept correct type of lesson" do
        correct_attr = @attr_timetable.merge( :tt_type => nil )
        Timetable.new( correct_attr ).should be_valid 
      end
    end
  end
end
