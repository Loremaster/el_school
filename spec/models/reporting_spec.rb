# == Schema Information
#
# Table name: reportings
#
#  id           :integer         not null, primary key
#  report_type  :string(255)
#  report_topic :string(255)
#  lesson_id    :integer
#  created_at   :datetime        not null
#  updated_at   :datetime        not null
#

require 'spec_helper'

describe Reporting do
  before(:each) do
    @lesson = FactoryGirl.create( :lesson )
    @attr_rep = { :lesson_id => @lesson.id, :report_type => "homework", :report_topic => "" }
  end

  describe "Reporting creation" do
    it "should be success" do
      expect do
        Reporting.create( @attr_rep )
      end.should change( Reporting, :count ).by( 1 )
    end

    it "should not success with invalid params" do
      expect do
        Reporting.create( @attr_rep.merge( :lesson_id => nil, :report_type => "" ) )
      end.should_not change( Reporting, :count )
    end
  end

  describe "Attendance association" do
    before(:each) do
      @reporting = Reporting.create( @attr_rep )
    end

    it "should have a lesson attribute" do
      @reporting.should respond_to( :lesson )
    end

    it "should have the right associated lesson" do
      @reporting.lesson_id.should == @lesson.id
      @reporting.lesson.should == @lesson
    end
  end

  describe "Validations" do
    describe "Rejection" do
      it "should reject invalid report type" do
        invalid_type = %w(1 2 sd dfdf gfdsds dfsdfd1)
        invalid_type.each do |i|
          Reporting.new( @attr_rep.merge( :report_type => i ) ).should_not be_valid
        end
      end

      it "should reject too long report topic" do
        wrong_attr = @attr_rep.merge( :report_topic => 'a' * 201 )
        Reporting.new( wrong_attr ).should_not be_valid
      end
    end

    describe "Acceptance" do
      it "should accept correct report type" do
        valid_type = %w(homework classwork labwork checkpoint)
        valid_type.each do |i|
          Reporting.new( @attr_rep.merge( :report_type => i ) ).should be_valid
        end
      end

      it "should accept report topic if length is correct" do
        (1..200).each do |i|
          correct_attr = @attr_rep.merge( :report_topic => 'a' * i  )
          Reporting.new( correct_attr ).should be_valid
        end
      end
    end
  end
end
