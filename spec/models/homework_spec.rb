# == Schema Information
#
# Table name: homeworks
#
#  id         :integer         not null, primary key
#  pupil_id   :integer
#  lesson_id  :integer
#  task_text  :string(255)
#  created_at :datetime        not null
#  updated_at :datetime        not null
#

require 'spec_helper'

describe Homework do
  before(:each) do
    @pupil = FactoryGirl.create( :pupil )
    @lesson = FactoryGirl.create( :lesson )
    @attr_hw = { :pupil_id => @pupil.id, :lesson_id => @lesson.id, :task_text => "bla" }
  end

  describe "Creation" do
    it "should create homework with valid attributes" do
      expect do
        Homework.create( @attr_hw ).should be_valid
      end.should change( Homework, :count ).by( 1 )
    end

    it "should not create homework with valid attributes" do
      expect do
        Homework.create( @attr_hw.merge( :pupil_id => nil, :lesson_id => nil )
                        ).should_not be_valid
      end.should_not change( Homework, :count )
    end
  end

  describe "Homework associations" do
    before(:each) do
      @hw = Homework.create( @attr_hw )
    end

    it "should have pupil attribute" do
      @hw.should respond_to( :pupil )
    end

    it "should have lesson attribute" do
      @hw.should respond_to( :lesson )
    end

    it "should have right associated pupil" do
      @hw.pupil_id.should == @pupil.id
      @hw.pupil.should == @pupil
    end

    it "should have right associated lesson" do
      @hw.lesson_id.should == @lesson.id
      @hw.lesson.should == @lesson
    end
  end

  describe "Validations" do
    describe "Rejection" do
      it "should reject nil pupil id" do
        wrong_attr = @attr_hw.merge( :pupil_id => nil )
        Homework.new( wrong_attr ).should_not be_valid
      end

      it "should reject nil lesson id" do
        wrong_attr = @attr_hw.merge( :lesson_id => nil )
        Homework.new( wrong_attr ).should_not be_valid
      end

      it "should reject too long task text" do
        wrong_attr = @attr_hw.merge( :task_text => 'a' * 251 )
        Homework.new( wrong_attr ).should_not be_valid
      end
    end

    describe "Acceptance" do
      it "should accept task text with valid length" do
        (1..250).each do |sym|
          correct_attr = @attr_hw.merge( :task_text => 'a' * sym )
          Homework.new( correct_attr ).should be_valid
        end
      end
    end
  end
end
