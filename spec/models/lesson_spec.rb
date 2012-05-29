# Created by 'bundle exec annotate --position before'
# == Schema Information
#
# Table name: lessons
#
#  id           :integer         not null, primary key
#  timetable_id :integer
#  lesson_date  :date
#  created_at   :datetime        not null
#  updated_at   :datetime        not null
#

require 'spec_helper'

describe Lesson do
  before(:each) do
    @school_class = FactoryGirl.create( :school_class )
    @curriculum = FactoryGirl.create( :curriculum )
    @attr_timetable = { :school_class_id => @school_class.id,
                        :curriculum_id => @curriculum.id,
                        :tt_day_of_week => "Mon",
                        :tt_number_of_lesson => 1,
                        :tt_room => '123',
                        :tt_type => 'Primary lesson' }
    @timetable = Timetable.create( @attr_timetable )

    @attr_lesson = {
      :timetable_id => @timetable.id,
      :lesson_date => "#{Date.today}"
    }
  end

  describe "Lesson creation" do
    it "should create valid lesson" do
      expect do
        Lesson.create( @attr_lesson ).should be_valid
      end.should change( Lesson, :count ).by( 1 )
    end

    it "should not create invalid lesson" do
      expect do
        Lesson.create(
                        @attr_lesson.merge( :timetable_id => nil, :lesson_date => '' )
                     ).should_not be_valid
      end.should_not change( Lesson, :count )
    end
  end

  describe "Lesson associations" do
    before(:each) do
      @lesson = Lesson.create( @attr_lesson )
    end

    it "should have school timetable" do
      @lesson.should respond_to( :timetable )
    end

    it "should have right associated timetable" do
      @lesson.timetable_id.should == @timetable.id
      @lesson.timetable.should == @timetable
    end
  end

  describe "Validations" do
    describe "Rejection" do
      it "should reject nil timetable_id" do
        wrong_attr = @attr_lesson.merge( :timetable_id => nil )
        Lesson.new( wrong_attr ).should_not be_valid
      end

      it "should reject date if it's < 15 years from nowdays" do
        dates = ( Date.today - 25.years )..( Date.today - 16.years )
        dates.each do |d|
          wrong_attr = @attr_lesson.merge( :lesson_date => d )
          Lesson.new( wrong_attr ).should_not be_valid
        end
      end

      it "should reject date if it's > 15 years from nowdays" do
        dates = ( Date.today + 16.years )..( Date.today + 25.years )
        dates.each do |d|
          wrong_attr = @attr_lesson.merge( :lesson_date => d )
          Lesson.new( wrong_attr ).should_not be_valid
        end
      end

      it "should reject dublicate pair of timetable_id + lesson_date" do
        expect do
          Lesson.create( @attr_lesson ).should be_valid
        end.should change( Lesson, :count ).by( 1 )

        expect do
          Lesson.create( @attr_lesson ).should_not be_valid
        end.should_not change( Lesson, :count )
      end
    end
  end
end
