# Created by 'bundle exec annotate --position before'
# == Schema Information
#
# Table name: attendances
#
#  id         :integer         not null, primary key
#  pupil_id   :integer
#  lesson_id  :integer
#  created_at :datetime        not null
#  updated_at :datetime        not null
#

require 'spec_helper'

describe Attendance do
  before(:each) do
    @pupil = FactoryGirl.create( :pupil )
    @lesson = FactoryGirl.create( :lesson )
  end

  describe "Attendance creation" do
    it "should be success" do
      expect do
        Attendance.create( :pupil_id => @pupil.id, :lesson_id => @lesson.id )
      end.should change( Attendance, :count ).by( 1 )
    end
  end

  describe "Attendance association" do
    before(:each) do
      @attendance = Attendance.create( :pupil_id => @pupil.id, :lesson_id => @lesson.id )
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
end
