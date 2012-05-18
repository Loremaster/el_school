# Created by 'bundle exec annotate --position before'
# == Schema Information
#
# Table name: attendances
#
#  id         :integer         not null, primary key
#  pupil_id   :integer
#  lesson_id  :integer
#  visited    :boolean
#  created_at :datetime        not null
#  updated_at :datetime        not null
#

require 'spec_helper'

describe Attendance do
  before(:each) do
    @pupil = FactoryGirl.create( :pupil )
    @lesson = FactoryGirl.create( :lesson )

    @attr_atte = { :pupil_id => @pupil.id, :lesson_id => @lesson.id, :visited => true }
  end

  describe "Attendance creation" do
    it "should be success" do
      expect do
        Attendance.create( :pupil_id => @pupil.id, :lesson_id => @lesson.id, :visited => true )
      end.should change( Attendance, :count ).by( 1 )
    end

    it "should not success with invalid params" do
      expect do
        Attendance.create( :pupil_id => nil, :lesson_id => nil, :visited => nil )
      end.should_not change( Attendance, :count )
    end
  end

  describe "Attendance association" do
    before(:each) do
      @attendance = Attendance.create( :pupil_id => @pupil.id, :lesson_id => @lesson.id,
                                       :visited => true )
    end

    it "should have a pupil attribute" do
      @attendance.should respond_to( :pupil )
    end

    it "should have a lesson attribute" do
      @attendance.should respond_to( :lesson )
    end

    it "should have the right associated pupil" do
      @attendance.pupil_id.should == @pupil.id
      @attendance.pupil.should == @pupil
    end

    it "should have the right associated lesson" do
      @attendance.lesson_id.should == @lesson.id
      @attendance.lesson.should == @lesson
    end
  end

  describe "Validations" do
    describe "Rejection" do
      it "should reject nil pupil id" do
        wrong_attr = @attr_atte.merge( :pupil_id => nil )
        Attendance.new( wrong_attr ).should_not be_valid
      end

      it "should reject nil lesson id" do
        wrong_attr = @attr_atte.merge( :lesson_id => nil )
        Attendance.new( wrong_attr ).should_not be_valid
      end

      it "should reject nil visited attr" do
        wrong_attr = @attr_atte.merge( :visited => nil )
        Attendance.new( wrong_attr ).should_not be_valid
      end
    end

    describe "Acceptance" do
      it "should accept visited == true" do
        correct_attr = @attr_atte.merge( :visited => true )
        Attendance.new( correct_attr ).should be_valid
      end

      it "should accept visited == false" do
        correct_attr = @attr_atte.merge( :visited => false )
        Attendance.new( correct_attr ).should be_valid
      end
    end
  end
end
